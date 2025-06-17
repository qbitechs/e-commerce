class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend

  helper_method :current_cart

  private

  def authenticate_customer!
    unless current_customer
      flash[:alert] = "You need to sign in as a customer to access this area."
      redirect_to root_path
    end
  end

  def current_cart
    current_customer&.cart
  end
end
