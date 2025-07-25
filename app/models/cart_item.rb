class CartItem < ApplicationRecord
  acts_as_tenant(:store)

  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    quantity * product.price
  end
end
