class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  enum :status, {
    pending: "pending",
    completed: "completed",
    canceled: "canceled"
  }, default: :pending


  validate :must_have_at_least_one_item

  private

  def must_have_at_least_one_item
    if order_items.empty?
      errors.add(:order_items, "must include at least one product")
    end
  end
end
