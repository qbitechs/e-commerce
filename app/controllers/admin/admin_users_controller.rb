class Admin::AdminUsersController < Admin::ApplicationController
  before_action :require_super_admin

  def index
    @admin_users = User.all
  end

  def switch_to
    user = User.find(params[:id])
    session[:true_user_id] = Current.user.id unless session[:true_user_id]
    terminate_session
    start_new_session_for(user)
    redirect_to admin_root_path, notice: "Now signed in as #{user.email_address}"
  end

  def switch_back
    terminate_session
    start_new_session_for(User.find(session[:true_user_id]))
    session[:true_user_id] = nil
    redirect_to admin_admin_users_path, notice: "Stopped impersonating."
  end
end
