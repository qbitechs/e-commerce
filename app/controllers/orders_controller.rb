class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [ :show, :edit, :update, :destroy ]

  def index
    @orders = current_user.orders
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.payment_method ||= "COD"

    if @order.save
      redirect_to @order, notice: "Order was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Order was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "Order was successfully destroyed."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "Not authorized." unless @order.customer == current_user
  end

  def order_params
    params.require(:order).permit(:shipping_address, :payment_method, :status, :total)
  end
end
