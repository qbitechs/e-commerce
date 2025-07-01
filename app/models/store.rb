class Store < ApplicationRecord
  belongs_to :user

  has_rich_text :description

  has_one :custom_domain, dependent: :destroy
  has_one_attached :logo
  has_one_attached :hero_image

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
            exclusion: { in: %w[www admin help support api platform] },
            unless: :has_custom_domain?
end

private

def has_custom_domain?
  custom_domain.present?
end
