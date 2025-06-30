class Admin::ApplicationController < ApplicationController
  include Authentication

  set_current_tenant_through_filter

  before_action :set_current_store

  def current_store
    Current.store = ActsAsTenant.current_tenant
  end
end
