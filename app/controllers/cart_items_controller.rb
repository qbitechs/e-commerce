class CartItemsController < ApplicationController
  before_action :set_product,  only: %i[ create update destroy]
  before_action :set_quantity, only: %i[ create update ]
  before_action :validate_quantity, only: %i[ create update ]

  def create
    if @validation_error
      flash[:alert] =  @validation_error
      redirect_back(fallback_location: root_path)
    elsif find_or_create_cart.add(@product, @quantity)
      flash[:success] = "#{@product.name} added to cart"
      redirect_to products_path
    else
      flash[:alert] = "Failed to add #{@product.name} to cart"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @validation_error
      flash[:alert] =  @validation_error
    elsif current_cart.update(@product, @quantity)
      flash[:success] = "Cart updated: #{@product.name} quantity changed to #{@quantity}"
    else
      flash[:alert] = "Failed to update #{@product.name}"
    end

    redirect_to cart_path
  end

  # DELETE /cart_items/:id
  def destroy
    if current_cart.remove(@product)
      flash[:success] = "#{@product.name} removed from cart"
    else
      flash[:notice] = "Failed to remove #{@product.name} from cart"
    end

    redirect_to cart_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_quantity
    @quantity = (params[:quantity] || cart_item_params[:quantity]).to_i
  end

  def validate_quantity
    @validation_error = @product.validate_cart_quantity(@quantity)
  end
end
