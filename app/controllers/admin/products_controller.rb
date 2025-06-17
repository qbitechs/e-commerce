class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @pagy, @products = pagy(Product.all)
    render "products/index"
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product created successfully."
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:success] = "Product updated."
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = "Product deleted."
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product)
          .permit(:name, :description, :price, :stock, :sku, :image)
  end
end
