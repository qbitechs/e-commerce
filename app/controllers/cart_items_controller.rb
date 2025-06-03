class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    # Either find an existing CartItem for this product, or build a new one
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity || 0) + (params[:quantity].to_i > 0 ? params[:quantity].to_i : 1)

    if cart_item.save
      redirect_to cart_path, notice: "#{product.name} was added to your cart."
    else
      redirect_back fallback_location: product_path(product), alert: "Unable to add to cart."
    end
  end

  def update
    cart_item = @cart.cart_items.find(params[:id])
    if params[:quantity].to_i <= 0
      cart_item.destroy
      redirect_to cart_path, notice: "Item removed from cart."
    else
      if cart_item.update(quantity: params[:quantity])
        redirect_to cart_path, notice: "Quantity updated."
      else
        redirect_to cart_path, alert: "Could not update quantity."
      end
    end
  end

  # DELETE /cart_items/:id
  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def ensure_customer!
    unless current_user.customer?
      redirect_to root_path, alert: "Only customers can shop."
    end
  end

  def set_cart
    @cart = current_customer&.cart
  end
end
