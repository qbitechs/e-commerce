class Admin::CustomersController < Admin::BaseController
  def index
    @q = Customer.ransack(params[:q])
    @pagy, @customers = pagy(@q.result(distinct: true))
  end
end
