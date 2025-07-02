class Admin::BaseController < ApplicationController
  layout "store_admin"

  include Authentication
  include CurrentStore
  include ApplicationHelper

  include Pagy::Backend

  set_current_tenant_through_filter

  before_action :set_current_store

  helper_method :user_signed_in?

  private

  def user_signed_in?
    Current.user.present?
  end

  def require_super_admin
    return if Current.user&.super_admin?

    redirect_to admin_root_path, alert: "Access denied."
  end

  def true_user
    @true_user ||= User.find(session[:true_user_id]) if session[:true_user_id]
  end
end
