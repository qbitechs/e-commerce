class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_customer, :current_admin, :current_cart

  private

  def current_customer
    return unless user_signed_in? && current_user.customer?
    current_user.customer
  end

  def current_admin
    return unless user_signed_in? && current_user.admin?
    current_user.admin
  end

  def current_cart
    current_customer&.current_cart
  end
end
