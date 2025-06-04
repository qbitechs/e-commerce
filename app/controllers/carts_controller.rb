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
      flash[:alert] = "Your cart is empty."
      redirect_to cart_path
      return
    end

    ActiveRecord::Base.transaction do
      # 1. Build a new Order for this customer
      @order = current_customer.orders.create!(
        order_params.merge(
          status: "pending",
          total:  @cart.total_price
        )
      )

      # 2. Convert each CartItem into an OrderItem
      @cart.cart_items.each do |ci|
        @order.order_items.create!(
          product_id:  ci.product_id,
          quantity:    ci.quantity,
          unit_price:  ci.product.price
        )
      end

      # Decrement the inventory stock
      @cart.cart_items.each do |cart_item|
        product = cart_item.product
        if product.stock >= cart_item.quantity
          product.decrement!(:stock, cart_item.quantity)
        else
          raise ActiveRecord::Rollback, "Not enough stock for #{product.name}"
        end
      end

      # 4. Clear out the cart
      @cart.clear!
    end

    flash[:success] = "Checkout successful! Your order ##{@order.id} has been placed."
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Checkout failed: #{e.message}"
    redirect_to cart_path
  end

  private

  def ensure_customer!
    unless current_user.customer?
      flash[:alert] = "Only customers can view a cart."
      redirect_to root_path
    end
  end

  def set_cart
    @cart = current_customer.cart
  end

  def order_params
    params.require(:order).permit(:recipient_first_name, :recipient_last_name, :recipient_phone, :shipping_address, :shipping_city, :shipping_country, :shipping_zip_code)
  end
end
