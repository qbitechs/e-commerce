class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include Pagy::Backend
  include CurrentStore

  helper_method :current_cart, :user_signed_in?

  set_current_tenant_through_filter

  before_action :set_meta_tags_from_db

  before_action :set_meta_tags_from_db

  def after_sign_in_path_for(resource)
    if resource.is_a?(Customer)
      merge_anonymous_cart
    end
    super
  end

  private

  def user_signed_in?
    Current.user.present?
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

  def set_meta_tags_from_db
    page = request.url
    meta_tag = MetaTag.find_by(page: page)
    if meta_tag
      set_meta_tags(title: meta_tag.title, description: meta_tag.description, keywords: meta_tag.keywords)
    end
  end
end
