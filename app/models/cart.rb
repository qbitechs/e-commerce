class Cart < ApplicationRecord
  belongs_to :customer
  has_many   :cart_items, dependent: :destroy
  has_many   :products, through: :cart_items

  def total_price
    cart_items.includes(:product).sum do |item|
      item.quantity * item.product.price
    end
  end

  def clear!
    cart_items.destroy_all
  end
end
