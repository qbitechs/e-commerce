class Admin::DashboardController < Admin::BaseController
  def index
    @product_count = Product.count
    @order_count   = Order.count
  end
end
