class StaticController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all)
    @categories = Category.all
  end
end
