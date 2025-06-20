class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend

  helper_method :current_cart, :admin_user_signed_in?

  private

  def current_cart
    current_customer&.cart
  end

  def admin_user_signed_in?
    Current.admin_user.present?
  end
end
