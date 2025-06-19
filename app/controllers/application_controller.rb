class ApplicationController < ActionController::Base
  before_action :set_current_cart

  allow_browser versions: :modern

  include Pagy::Backend

  helper_method :current_cart, :admin_user_signed_in?

  private

  def admin_user_signed_in?
    Current.admin_user.present?
  end

  def cart_service
    @cart_service ||= CartService.new(session, current_customer)
  end

  def current_cart
    cart_service.current_cart
  end

  def set_current_cart
    @current_cart = current_cart
  end

  def merge_anonymous_cart
    cart_service.merge_anonymous_cart_on_login(current_customer) if current_customer
  end
end
