class Admin::OrdersController < Admin::BaseController
  def index
    @q = Order.ransack(params[:q])

    @pagy, @orders = pagy(@q.result(distinct: true).includes(:customer, order_items: :product).order(created_at: :desc))
    scoped = @q.result(distinct: true)
    @total_orders     = scoped.count
    @pending_orders   = scoped.where(status: "pending").count
    @completed_orders = scoped.where(status: "completed").count
  end
end
