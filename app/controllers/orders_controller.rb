class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @orders = pagy(current_customer&.orders)
  end
end
