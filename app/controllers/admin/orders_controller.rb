class Admin::OrdersController < Admin::ApplicationController
  def index
    @pagy, @orders = pagy(Order.includes(:customer, order_items: :product).order(created_at: :desc))

    @total_orders = Order.count
    @pending_orders = Order.where(status: "pending").count
    @completed_orders = Order.where(status: "completed").count
  end
end
