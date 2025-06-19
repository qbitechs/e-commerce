# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_customer!, only: %i[ checkout ]
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:product)
    @total_price = @cart.total_price
  end

  def checkout
    return redirect_if_empty_cart if @cart.cart_items.empty?

    begin
      ActiveRecord::Base.transaction do
        build_order!
        create_order_items!
        decrement_stock!
        @cart.clear!
      end

      flash[:success] = "Checkout successful! Your order ##{@order.id} has been placed."
      redirect_to root_path

    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Validation failed: #{e.record.errors.full_messages.join(', ')}"
      redirect_to cart_path

    rescue StandardError => e
      flash[:alert] = e.message
      redirect_to cart_path
    end
  end

  private

  def set_cart
    @cart = current_customer.cart
  end

  def redirect_if_empty_cart
    flash[:alert] = "Your cart is empty. Checkout cannot proceed."
    redirect_to cart_path
  end

  def build_order!
    @order = current_customer.orders.create!(
      order_params.merge(
        status: "pending",
        total:  @cart.total_price
      )
    )
  end

  def create_order_items!
    @cart.cart_items.each do |ci|
      @order.order_items.create!(
        product_id: ci.product_id,
        quantity:   ci.quantity,
        unit_price: ci.product.price
      )
    end
  end

  def decrement_stock!
    @cart.cart_items.each do |ci|
      product = ci.product
      if product.stock >= ci.quantity
        product.decrement!(:stock, ci.quantity)
      else
        raise StandardError.new("Not enough stock for #{product.name}")
      end
    end
  end

  def order_params
    params.require(:order).permit(:recipient_first_name, :recipient_last_name, :recipient_phone, :shipping_address, :shipping_city, :shipping_country, :shipping_zip_code)
  end
end
