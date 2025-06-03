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
      flash[:success] = "#{product.name} was added to your cart."
      redirect_to cart_path
    else
      flash[:alert] = "Unable to add to cart."
      redirect_back fallback_location: product_path(product)
    end
  end

  def update
    cart_item = @cart.cart_items.find(params[:id])
    if params[:quantity].to_i <= 0
      cart_item.destroy
      flash[:success] = "Item removed from cart."
      redirect_to cart_path
    else
      if cart_item.update(quantity: params[:quantity])
        flash[:success] = "Quantity updated."
        redirect_to cart_path
      else
        flash[:alert] = "Could not update quantity."
        redirect_to cart_path
      end
    end
  end

  # DELETE /cart_items/:id
  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    flash[:success] = "Item removed from cart."
    redirect_to cart_path
  end

  private

  def ensure_customer!
    unless current_user.customer?
      flash[:alert] = "Only customers can shop."
      redirect_to root_path
    end
  end

  def set_cart
    @cart = current_customer&.cart
  end
end
