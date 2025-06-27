class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include Pagy::Backend

  helper_method :current_cart, :admin_user_signed_in?

  set_current_tenant_through_filter
  before_action :set_current_store

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

  def set_current_store
    # Identify store by subdomain or custom domain
    host = request.host
    subdomain = request.subdomains.first
    if subdomain.present?
      store = Store.find_by(subdomain: subdomain)
    else
      store = Store.joins(:custom_domain).find_by(custom_domains: { domain: host })
    end
    if store
      ActsAsTenant.current_tenant = store
    else
      # Optionally handle missing store (redirect or error)
      ActsAsTenant.current_tenant = nil
    end
  end
end
