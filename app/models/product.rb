class Product < ApplicationRecord
  has_many_attached :images
  has_many :order_items
  has_many :orders, through: :order_items
end
