class Admin::CustomersController < Admin::ApplicationController
  def index
    @q = Customer.ransack(params[:q])
    @pagy, @customers = pagy(@q.result(distinct: true))
  end
end
