require "acme-client"
require "fileutils"

class SslCertificateService
  LETS_ENCRYPT_DIRECTORY = "https://acme-v02.api.letsencrypt.org/directory"
  # Use a shared Docker volume path for certs, e.g., /shared/certs
  CERTS_BASE_PATH = "/etc/letsencrypt/live"

  # Use a class method to make it easier to call from a job
  def self.generate_for(custom_domain = nil, domain_name = nil)
    # Ensure the custom domain is valid and has not been processed yet
    raise "Custom domain or domain should be present" if custom_domain.blank? && domain_name.blank?

    domain = cutom_domain&.domain || domain_name
    # Create an instance of the service and call the method to generate and store the certificate
    result = new(domain).generate_and_store
    if result.empty?
      Rails.logger.error("SSL Certificate generation failed for #{domain}")
    else
      Rails.logger.info("SSL Certificate generated for #{domain}")
      custom_domain&.update(status: CustomDomain.statuses[:active], verified_at: Time.current)
    end
  end

  def initialize(custom_domain)
    @domain = custom_domain
    @private_key = OpenSSL::PKey::RSA.new(4096)
    # Use the single account private key stored in credentials for Let's Encrypt account
    account_key = OpenSSL::PKey::RSA.new(Rails.application.credentials.lets_encrypt.private_key)
    @client = Acme::Client.new(private_key: account_key, directory: LETS_ENCRYPT_DIRECTORY)
  end

  def generate_and_store
    order = @client.new_order(identifiers: [ @domain ])
    authorization = order.authorizations.first
    challenge = authorization.http

    # Write challenge file /etc/letsencrypt/challenges
    challenge_dir = "/etc/letsencrypt/challenges"
    FileUtils.mkdir_p(challenge_dir)
    File.write(File.join(challenge_dir, challenge.token), challenge.file_content)

    begin
      # Ask Let's Encrypt to validate
      challenge.request_validation

      # Poll for validation status. In a real-world app, you might want more
      # robust polling with exponential backoff or a webhook system.
      10.times do
        break if challenge.status != "pending"
        sleep(2)
        challenge.reload
      end

      raise "Challenge validation failed: #{challenge.error['detail']}" unless challenge.status == "valid"

      # Finalize the order to get the certificate
      csr = Acme::Client::CertificateRequest.new(
        private_key: @private_key,
        subject: { common_name: @domain }
      )
      order.finalize(csr: csr)

      # Poll for order completion
      10.times do
        break if order.status != "processing"
        sleep(2)
        order.reload
      end

      raise "Order failed: #{order.errors.first['detail']}" unless order.status == "valid"

      cert = order.certificate
      store_certificate(cert, @private_key.to_pem)
      [ cert, @private_key.to_pem ]
    rescue StandardError => e
      Rails.logger.error("SSL Certificate generation failed for #{@domain}: #{e.message}")
      []
    ensure
      # Clean up the challenge from the database regardless of success or failure
      File.delete(File.join(challenge_dir, challenge.token))
    end
  end

  def store_certificate(cert, key)
    dest_dir = File.join(CERTS_BASE_PATH, @domain)
    FileUtils.mkdir_p(dest_dir)
    File.write(File.join(dest_dir, "fullchain.pem"), cert)
    File.write(File.join(dest_dir, "privkey.pem"), key)
  end
end
