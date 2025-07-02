class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new create edit update]

  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result(distinct: true))
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product created successfully."
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:success] = "Product updated."
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = "Product deleted."
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :sku, :image, :category_id)
  end
end
