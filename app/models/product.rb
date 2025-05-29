class Product < ApplicationRecord
  has_one_attached :image

  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, :price, :stock, :sku, presence: true
end
