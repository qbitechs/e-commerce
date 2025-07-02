class Admin::BaseController < ApplicationController
  layout "store_admin"

  include Authentication
  include CurrentStore

  include Pagy::Backend

  set_current_tenant_through_filter

  before_action :set_current_store

  helper_method :admin_user_signed_in?

  private

  def admin_user_signed_in?
    Current.admin_user.present?
  end
end
