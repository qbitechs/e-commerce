class Admin::ApplicationController < ApplicationController
  include Authentication
  before_action :require_authentication

  def require_super_admin
    unless Current.admin_user&.super_admin?
      redirect_to admin_root_path, alert: "Access denied."
    end
  end
end
