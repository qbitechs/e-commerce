# app/controllers/carts_controller.rb
class Store::CartsController < ApplicationController
  def show
    @cart_items = current_cart&.cart_items&.includes(:product)
    @total_price = current_cart&.total_price
  end

  def checkout
    return redirect_if_empty_cart if current_cart&.cart_items.empty?

    begin
      ActiveRecord::Base.transaction do
        # Create or find customer first
        @customer = find_or_create_customer!

        # Build and save the order
        build_order!
        create_order_items!
        decrement_stock!

        # Clear the cart
        current_cart&.clear!

        # Sign in the customer if they're not already signed in
        sign_in(@customer) unless current_customer
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

  def redirect_if_empty_cart
    flash[:alert] = "Your cart is empty. Checkout cannot proceed."
    redirect_to cart_path
  end

  def find_or_create_customer!
    if current_customer
      # User is already logged in
      current_customer
    else
      # Guest checkout - handle authentication
      email = params[:email]
      password = params[:password]
      first_name = params[:order][:recipient_first_name]
      last_name = params[:order][:recipient_last_name]

      # Check if customer already exists
      existing_customer = Customer.find_by(email: email)

      if existing_customer
        # Customer exists - verify password
        if existing_customer.valid_password?(password)
          existing_customer
        else
          raise StandardError.new("Invalid email or password. Please check your credentials.")
        end
      else
        # Create new customer with provided password
        Customer.create!(
          email: email,
          first_name: first_name,
          last_name: last_name,
          password: password,
          password_confirmation: password
        )
      end
    end
  end


  def build_order!
    @order = @customer.orders.create!(
      order_params.merge(
        status: "pending",
        total: current_cart&.total_price
      )
    )
  end

  def create_order_items!
    current_cart&.cart_items.each do |ci|
      @order.order_items.create!(
        product_id: ci.product_id,
        quantity: ci.quantity,
        unit_price: ci.product.price
      )
    end
  end

  def decrement_stock!
    current_cart&.cart_items.each do |ci|
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
