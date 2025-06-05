class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all, limit: 2)
  end

  def show
    @product = Product.find(params[:id])
  end
end
