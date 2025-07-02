class Store::BaseController < ActionController::Base
  layout "store"

  include CurrentStore
  include Pagy::Backend

  helper_method :current_cart, :admin_user_signed_in?

  set_current_tenant_through_filter

  def after_sign_in_path_for(resource)
    if resource.is_a?(Customer)
      merge_anonymous_cart
    end
    super
  end

  private

  def admin_user_signed_in?
    Current.admin_user.present?
  end

  def cart_service
    @cart_service ||= CartService.new(session, current_customer)
  end

  def current_cart
    cart_service.find_existing_cart
  end

  def find_or_create_cart
    cart_service.find_or_create_cart
  end

  def merge_anonymous_cart
    cart_service.merge_anonymous_cart_on_login(current_customer) if current_customer
  end
end
