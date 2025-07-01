class Admin::ApplicationController < ApplicationController
  include Authentication

  set_current_tenant_through_filter

  before_action :set_current_store
  before_action :require_authentication

  private

  def require_super_admin
    unless Current.user&.super_admin?
      redirect_to admin_root_path, alert: "Access denied."
    end
  end
end
