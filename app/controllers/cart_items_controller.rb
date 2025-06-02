class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!

  def create
    cart   = current_cart
    product = Product.find(params[:product_id])

    if product.stock < (params[:quantity].to_i.nonzero? || 1)
      render json: { error: "Insufficient stock" }, status: :unprocessable_entity
      return
    end

    item = cart.order_items.find_or_initialize_by(product: product)

    item.quantity = (item.quantity || 0) + (params[:quantity].to_i.nonzero? || 1)
    item.unit_price = product.price
    if item.save
      cart.calculate_total!
      render json: { success: true, cart: cart_summary(cart) }, status: :ok
    else
      render json: { error: item.errors.full_messages.join(", ") },
             status: :unprocessable_entity
    end
  end

  def update
    cart_item = current_cart.order_items.find(params[:id])

    if cart_item.nil?
      head :not_found
      return
    end

    # Validate stock again
    if cart_item.product.stock < params[:quantity].to_i
      render json: { error: "Insufficient stock" }, status: :unprocessable_entity
      return
    end

    cart_item.quantity = params[:quantity].to_i
    if cart_item.save
      current_cart.calculate_total!
      render json: { success: true, cart: cart_summary(current_cart) }, status: :ok
    else
      render json: { error: cart_item.errors.full_messages.join(", ") },
             status: :unprocessable_entity
    end
  end

  # DELETE /cart_items/:id
  def destroy
    cart_item = current_cart.order_items.find(params[:id])
    cart_item.destroy!
    current_cart.calculate_total!
    render json: { success: true, cart: cart_summary(current_cart) }, status: :ok
  end

  private


  def cart_summary(cart)
    {
      id: cart.id,
      total: cart.total,
      items: cart.order_items.includes(:product).map do |item|
        {
          id: item.id,
          product_id: item.product_id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.unit_price.to_f,
          subtotal: (item.quantity * item.unit_price).to_f
        }
      end
    }
  end

  def ensure_customer!
    unless current_user.customer?
      redirect_to root_path, alert: "Only customers can shop."
    end
  end
end
