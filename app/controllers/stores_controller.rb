class StoresController < ApplicationController
  def show
    @store = Current.store
    if @store
      @pagy, @products = pagy(@store.products)
      @categories = @store.categories.first(3)
    else
      render "static/not_found", status: :not_found
    end
  end
end
