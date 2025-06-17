class Admin::OrdersController < ApplicationController
  before_action :set_order, only: %i[show update]

  def index
    @orders = Order.all
  end

  def show; end

  def update
    if @order.update(order_params)
      flash[:success] = "Order status updated."
      redirect_to admin_order_path(@order)
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
