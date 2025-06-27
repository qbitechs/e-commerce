class StaticController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all)
    @categories = @products.distinct.pluck(:category)
  end
end
