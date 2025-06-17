class Admin::SessionsController < ApplicationController
  skip_before_action :require_admin, only: [ :new, :create ]
  layout "admin"

  def new
    redirect_to admin_dashboard_path if admin_signed_in?
  end

  def create
    admin = AdminUser.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_dashboard_path, notice: "Successfully logged in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: "Successfully logged out!"
  end
end
