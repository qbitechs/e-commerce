class CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_product, only: %w[ create update ]
  before_action :set_cart
  before_action :set_cart_item, only: %w[ update destroy ]

  def create
    # Either find an existing CartItem for this product, or build a new one
    cart_item = @cart.cart_items.find_or_initialize_by(product: @product)

    cart_item.quantity = (params[:quantity] || 1).to_i

    return if check_stock_and_quantity(cart_item.quantity, @product, root_path)

    if cart_item.save
      flash[:success] = "#{@product.name} was added to your cart."
      redirect_to root_path
    else
      flash[:alert] = "Unable to add to cart."
      redirect_back fallback_location: product_path(@product)
    end
  end

  def update
    quantity = cart_item_params[:quantity]

    return if check_stock_and_quantity(quantity, @product, cart_path)

    if @cart_item.update(cart_item_params)
      flash[:success] = "Quantity updated."
      redirect_to cart_path
    else
      flash[:alert] = "Could not update quantity."
      redirect_to cart_path
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
    unless current_customer
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

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def check_stock_and_quantity(quantity, product, path)
    if product.stock == 0
      flash[:alert] = "Currently! #{product.name} is out of stock."
      redirect_to path
    elsif quantity.to_i > product.stock
      flash[:alert] = "Only #{product.stock} items available."
      redirect_to path
      true
    elsif quantity.to_i <= 0
      flash[:alert] = "Could not update must have one item."
      redirect_to path
    end
  end
end
