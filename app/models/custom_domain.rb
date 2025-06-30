class CustomDomain < ApplicationRecord
  acts_as_tenant(:store)

  validates :domain, presence: true, uniqueness: { scope: :store_id }
  validates_format_of :domain, with: /\A[a-z0-9]+([-.][a-z0-9]+)*\.[a-z]{2,}\z/i, message: "must be a valid domain format"
end
