class Product < ApplicationRecord
  has_one_attached :image

  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, :price, :stock, :sku, presence: true

  def validate_cart_quantity(quantity)
    return "Currently! #{name} is out of stock." if stock == 0
    return "Only #{stock} items available." if quantity > stock
    return "Must have at least one item." if quantity <= 0
    nil
  end
end
