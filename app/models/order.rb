class Order < ApplicationRecord
  acts_as_tenant(:store)

  STATUSES = %w[pending paid shipped cancelled]

  belongs_to :customer
  has_many   :order_items, dependent: :destroy
  has_many   :products, through: :order_items

  validates :total, presence: true
  validates :status, inclusion: { in: STATUSES }

  def calculate_total!
    update!(total: order_items.sum { |item| item.quantity * item.unit_price })
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "status", "recipient_last_name", "recipient_first_name", "total", "created_at", "id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
