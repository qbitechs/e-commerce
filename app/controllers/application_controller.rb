class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend

  helper_method :current_cart, :admin_signed_in?, :current_admin

  private

  def current_cart
    current_customer&.cart
  end

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:admin_id]) if session[:admin_id]
  end

  def admin_signed_in?
    current_admin.present?
  end

  def require_admin
    unless admin_signed_in?
      redirect_to admin_login_path, alert: "Please sign in to access this area."
    end
  end
end
