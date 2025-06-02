class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :set_unit_price, on: :create

  validates :quantity, :unit_price, numericality: { greater_than: 0 }

  private

  def set_unit_price
    self.unit_price ||= product.price
  end
end
