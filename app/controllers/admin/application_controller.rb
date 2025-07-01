class Admin::ApplicationController < ApplicationController
  include Authentication

  set_current_tenant_through_filter

  before_action :set_current_store
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless Current.user
      redirect_to root_path, alert: "You must be signed in as an admin to access that page."
    end
  end

  def require_super_admin
    unless Current.user&.super_admin?
      redirect_to admin_root_path, alert: "Access denied."
    end
  end
end
