class CartItemsController < ApplicationController
  before_action :set_product,  only: %i[ create update destroy]
  before_action :set_quantity, only: %i[ create update ]
  before_action :validate_quantity, only: %i[ create update ]

  def create
    if @validation_error
      flash[:alert] = error
    elsif current_cart.add(@product, @quantity)
      flash[:notice] = "#{@product.name} added to cart"
    else
      flash[:alert] = "Unable to add item to cart"
    end

    redirect_back(fallback_location: root_path)
  end

  def update
    if @validation_error
      flash[:alert] = error
    elsif current_cart.update(@product, @quantity)
      flash[:notice] = "#{@product.name} added to cart"
    else
      flash[:alert] = "Unable to add item to cart"
    end

    redirect_to cart_path
  end

  # DELETE /cart_items/:id
  def destroy
    if current_cart.remove(@product)
      flash[:notice] = "#{@product.name} removed from cart"
    else
      flash[:notice] = "Unable to remove #{@product.name} from cart"
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
    @quantity = cart_item_params[:quantity].to_i || params[:quantity].to_i
  end

  def validate_quantity
    @validation_error = @product.validate_cart_quantity(@quantity)
  end
end
