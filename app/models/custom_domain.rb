class CustomDomain < ApplicationRecord
  acts_as_tenant(:store)

  validates :domain, presence: true, uniqueness: { scope: :store_id }
  validates_format_of :domain, with: /\A[a-z0-9]+([-.][a-z0-9]+)*\.[a-z]{2,}\z/i, message: "must be a valid domain format"

  enum :status, { active: 0, pending: 1, inactive: 2 }

  after_commit :enqueue_ssl_certificate_job, if: :saved_change_to_domain?

  private

  def enqueue_ssl_certificate_job
    return if domain.blank?

    SslCertificateJob.perform_later(self.id)
  end
end
