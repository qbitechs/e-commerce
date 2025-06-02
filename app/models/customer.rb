class Customer < ApplicationRecord
  belongs_to :user
  has_many   :orders, dependent: :destroy

  def current_cart
    orders.find_by(status: "cart") || orders.create!(status: "cart", total: 0)
  end
end
