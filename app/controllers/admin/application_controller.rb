class Admin::ApplicationController < ApplicationController
  include Authentication
  before_action :require_authentication

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
