
class Store::ProductsController < Store::BaseController
  def index
    @pagy, @products = pagy(Product.all)
  end

  def show
    @product = Product.find(params[:id])
  end
end
