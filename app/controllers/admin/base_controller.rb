class Admin::BaseController < ApplicationController
  layout "store_admin"

  include Authentication

  set_current_tenant_through_filter

  before_action :set_current_store
end
