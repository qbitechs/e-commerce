class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user&.customer&.orders
  end

  def show
    @order = current_user&.customer&.orders.find(params[:id])
  end
end
