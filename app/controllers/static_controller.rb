class StaticController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all)
    @categories = Category.first(3)
  end
end
