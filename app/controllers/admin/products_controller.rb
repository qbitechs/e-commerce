class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new create edit update]

  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result(distinct: true))
  end

  def show; end

  def new
    @product = Product.new
    @product.build_category
  end


  def create
    prepare_product_with_category

    if @product.save
      flash[:success] = "Product created successfully."
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit; end

  def update
    prepare_product_with_category(update: true)

    if @product.errors.empty? && @product.save
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

  def prepare_product_with_category(update: false)
    category_input = product_params.dig(:category_attributes, :name)&.strip

    if category_input.present?
      existing_category = find_existing_category(category_input)

      if existing_category
        assign_existing_category(existing_category, update)
      else
        assign_new_category(update)
      end
    else
      assign_direct_params(update)
    end
  end

  def find_existing_category(category_input)
    Category.find_by(id: category_input) ||
    Category.find_by("LOWER(name) = ?", category_input.downcase)
  end

  def assign_existing_category(existing_category, update)
    filtered_params = product_params.except(:category_attributes)

    if update
      @product.assign_attributes(filtered_params)
      @product.category = existing_category
    else
      @product = Product.new(filtered_params)
      @product.category = existing_category
    end
  end

  def assign_new_category(update)
    if update
      @product.assign_attributes(product_params)
    else
      @product = Product.new(product_params)
    end
  end

  def assign_direct_params(update)
    if update
      @product.assign_attributes(product_params)
    else
      @product = Product.new(product_params)
    end
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :sku, :image, :category_id, category_attributes: [ :name ])
  end
end
