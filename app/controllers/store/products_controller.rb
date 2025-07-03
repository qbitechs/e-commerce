
class Store::ProductsController < Store::BaseController
  def index
    if params[:category].present?
      @pagy, @products = pagy(Product.where(category: params[:category]))
    else
      @pagy, @products = pagy(Product.all)
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
