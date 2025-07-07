class SslCertificateJob < ApplicationJob
  queue_as :default

  def perform(custom_domain_id)
    custom_domain = CustomDomain.find_by(id: custom_domain_id)
    return unless custom_domain

    SslCertificateService.generate_for(custom_domain: custom_domain)
  end
end
