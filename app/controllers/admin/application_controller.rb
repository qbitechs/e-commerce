class Admin::ApplicationController < ApplicationController
  include Authentication

  helper_method :admin_user_signed_in?

  private

  def admin_user_signed_in?
    Current.admin_user.present?
  end
end
