class Order < ApplicationRecord
  STATUSES = %w[cart pending paid shipped cancelled]

  belongs_to :customer
  has_many   :order_items, dependent: :destroy
  has_many   :products, through: :order_items

  validates :total, presence: true
  validates :status, inclusion: { in: STATUSES }

  def calculate_total!
    update!(total: order_items.sum { |item| item.quantity * item.unit_price })
  end
end
