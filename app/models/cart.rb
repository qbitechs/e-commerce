class Cart < ApplicationRecord
  belongs_to :customer, optional: true
  has_many   :cart_items, dependent: :destroy
  has_many   :products, through: :cart_items

  validates :session_id, presence: true, if: -> { customer_id.blank? }
  validates :customer_id, presence: true, if: -> { session_id.blank? }
  validate :must_have_customer_or_session

  scope :anonymous, -> { where(customer_id: nil) }
  scope :authenticated, -> { where.not(customer_id: nil) }

  def self.find_or_create_for_customer(customer)
    find_or_create_by(customer: customer)
  end

  def self.find_or_create_for_session(session_id)
    find_or_create_by(session_id: session_id, customer_id: nil)
  end

  def total_price
    cart_items.includes(:product).sum do |item|
      item.quantity * item.product.price
    end
  end

  def clear!
    cart_items.destroy_all
  end

  def anonymous?
    customer_id.blank?
  end

  def authenticated?
    customer_id.present?
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def add(product, quantity = 1)
    current_item = cart_items.find_by(product: product)

    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      cart_items.create(product: product, quantity: quantity)
    end
  end

  def remove(product)
    cart_items.find_by(product: product)&.destroy
  end

  def update(product, quantity) # done
    item = cart_items.find_by(product: product)
    return false unless item

    if quantity > 0
      item.update(quantity: quantity)
    end
  end

  def merge_with(other_cart)
    return if other_cart.nil? || other_cart == self

    other_cart.cart_items.each do |item|
      add(item.product, item.quantity)
    end

    other_cart.destroy
  end

  private

  def must_have_customer_or_session
    if customer_id.blank? && session_id.blank?
      errors.add(:base, "Cart must belong to either a customer or session")
    end
  end
end
