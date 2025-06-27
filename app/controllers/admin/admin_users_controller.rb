class Admin::AdminUsersController < Admin::ApplicationController
  before_action :require_super_admin

  def index
    @admin_users = AdminUser.all
  end

  def switch_to
    admin = AdminUser.find(params[:id])
    session[:original_admin_user_id] = Current.admin_user.id unless session[:original_admin_user_id]
    session[:admin_user_id] = admin.id
    redirect_to admin_root_path, notice: "Now signed in as #{admin.email_address}"
  end

  def switch_back
    session[:admin_user_id] = session.delete(:original_admin_user_id)
    redirect_to admin_admin_users_path, notice: "Stopped impersonating."
  end
end
