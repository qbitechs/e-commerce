class Admin::DashboardController < Admin::ApplicationController
  def index
    @product_count = Product.count
    @order_count   = Order.count
  end
end
