class StaticController < ApplicationController
  def index
    @pagy, @products = pagy(Product.all)
  end
end
