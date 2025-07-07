class Admin::AdminUsersController < Admin::BaseController
  before_action :require_super_admin, only: %i[index switch_to]

  def index
    @users = User.all
  end

  def switch_to
    user = User.find(params[:id])
    session[:true_user_id] = Current.user.id unless session[:true_user_id]
    terminate_session
    start_new_session_for(user)
    redirect_to admin_root_path, flash: { success: "Now signed in as #{user.email_address}" }
  end

  def switch_back
    if true_user.blank?
      return redirect_to admin_admin_users_path
    end

    terminate_session
    start_new_session_for(true_user)
    session[:true_user_id] = nil
    redirect_to admin_admin_users_path, flash: { success: "Stopped impersonating." }
  end
end
