class Store < ApplicationRecord
  belongs_to :admin_user

  has_one :custom_domain, dependent: :destroy

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  accepts_nested_attributes_for :custom_domain, allow_destroy: true

  # Subdomain must be unique and not a reserved word.
  validates :subdomain,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ },
            exclusion: { in: %w(www admin help support api platform) }
end
