class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all, items: 10)
  end

  def show
    @product = Product.find(params[:id])
  end
end
