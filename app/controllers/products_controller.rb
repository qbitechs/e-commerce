class ProductsController < ApplicationController
  before_action :authenticate_customer!, only: %i[show]
  def index
    @pagy, @products = pagy(Product.all)
  end

  def show
    @product = Product.find(params[:id])
  end
end
