class Store < ApplicationRecord
  has_one :custom_domain, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :cart_items, dependent: :destroy
end
