class Admin::CustomersController < Admin::ApplicationController
  before_action :prevent_super_admin_direct_access
  def index
    @q = Customer.ransack(params[:q])
    @pagy, @customers = pagy(@q.result(distinct: true))
  end
end
