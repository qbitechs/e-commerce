class Admin::ApplicationController < ApplicationController
  include Authentication

  set_current_tenant_through_filter

  before_action :set_current_store
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless Current.admin_user
      redirect_to root_path, alert: "You must be signed in as an admin to access that page."
    end
  end

  def require_super_admin
    unless Current.admin_user&.super_admin?
      redirect_to admin_root_path, alert: "Access denied."
    end
  end

  private

  def prevent_super_admin_direct_access
    if Current.admin_user&.super_admin? && session[:original_admin_user_id].nil?
      redirect_to admin_admin_users_path, alert: "Super admins must switch to as an admin to access this section."
    end
  end
end
