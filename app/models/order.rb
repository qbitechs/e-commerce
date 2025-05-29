class Order < ApplicationRecord
  belongs_to :customer
  has_many   :order_items, dependent: :destroy
  has_many   :products, through: :order_items

  validates :status, :total, presence: true

  enum :status, {
    pending: "pending",
    paid: "paid",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }
end
