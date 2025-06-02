# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!

  def show
    @cart = current_cart
    @cart_items = @cart.order_items
  end

  private

  def ensure_customer!
    unless current_user.customer?
      redirect_to root_path, alert: "Only customers can view a cart."
    end
  end
end
