class Admin::ApplicationController < ApplicationController
  include Authentication
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless Current.admin_user
      redirect_to root_path, alert: "You must be signed in as an admin to access that page."
    end
  end
end
