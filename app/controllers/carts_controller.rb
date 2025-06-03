# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
    @total_price = @cart.total_price
  end

  def checkout
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    ActiveRecord::Base.transaction do
      # 1. Build a new Order for this customer
      order = current_user.customer.orders.create!(
        status: "pending",            # or whatever default you want
        total:  @cart.total_price
      )

      # 2. Convert each CartItem into an OrderItem
      @cart.cart_items.each do |ci|
        order.order_items.create!(
          product_id:  ci.product_id,
          quantity:    ci.quantity,
          unit_price:  ci.product.price
        )
      end

      # 3. (Optional) Update inventory: subtract stock
      #    You might do something like:
      #    @cart.cart_items.each { |ci| ci.product.decrement!(:stock, ci.quantity) }

      # 4. Clear out the cart
      @cart.clear!
    end

    redirect_to order_path(order), notice: "Checkout successful! Your order ##{order.id} has been placed."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cart_path, alert: "Checkout failed: #{e.message}"
  end

  private

  def ensure_customer!
    unless current_user.customer?
      redirect_to root_path, alert: "Only customers can view a cart."
    end
  end

  def set_cart
    @cart = current_user.customer.current_cart
  end
end
