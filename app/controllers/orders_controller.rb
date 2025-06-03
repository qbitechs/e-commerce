class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_customer&.orders
  end
end
