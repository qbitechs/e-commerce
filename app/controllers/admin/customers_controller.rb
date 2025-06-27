class Admin::CustomersController < Admin::ApplicationController
  def index
    @pagy, @customers = pagy(Customer.all)
  end
end
