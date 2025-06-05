class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!
  before_action :set_product
  before_action :set_cart
  before_action :set_cart_items, only: %w[ update destroy ]

  def create
    # Either find an existing CartItem for this product, or build a new one
    cart_item = @cart.cart_items.find_or_initialize_by(product: @product)
    cart_item.quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    return if check_stock(cart_item, @product)

    if cart_item.save
      flash[:success] = "#{@product.name} was added to your cart."
      redirect_to cart_items_path
    else
      flash[:alert] = "Unable to add to cart."
      redirect_back fallback_location: product_path(@product)
    end
  end

  def update
    quantity = cart_item_params[:quantity]
    return if check_stock(quantity, @product)

    if quantity.to_i <= 0
      flash[:alert] = "Could not update must have one item."
      redirect_to cart_path
    else
      if cart_item.update(cart_item_params)
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
    @cart_item.destroy
    flash[:success] = "Item removed from cart."
    redirect_to cart_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def ensure_customer!
    unless current_user.customer?
      flash[:alert] = "Only customers can shop."
      redirect_to root_path
    end
  end

  def set_cart
    @cart = current_customer&.cart
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_cart_items
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def check_stock(cart_item, product)
    if cart_item.quantity > product.stock
      flash[:alert] = "Only #{product.stock} items available."
      redirect_back(fallback_location: product_path(product))
      true
    end
  end
end
