class Admin::AdminUsersController < Admin::ApplicationController
  before_action :require_super_admin

  def index
    @admin_users = User.all
  end

  def switch_to
    admin = User.find(params[:id])
    session[:super_admin_id] = Current.user.id unless session[:super_admin_id]
    session[:admin_id] = admin.id
    redirect_to admin_root_path, notice: "Now signed in as #{admin.email_address}"
  end

  def switch_back
    session[:admin_id] = nil
    redirect_to admin_admin_users_path, notice: "Stopped impersonating."
  end
end
