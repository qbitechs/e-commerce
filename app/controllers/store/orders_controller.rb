class Store::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @pagy, @orders = pagy(current_customer.orders)
  end
end
