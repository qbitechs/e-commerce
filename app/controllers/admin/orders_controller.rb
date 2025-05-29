class Admin::OrdersController < Admin::ApplicationController
  before_action :set_order, only: %i[show update]

  def index
    @orders = Order.all(created_at: :desc)
  end

  def show; end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Order status updated."
    else
      render :show
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
