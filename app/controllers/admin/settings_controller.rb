class Admin::SettingsController < Admin::BaseController
  before_action :set_store

  def edit; end

  def update
    if @store.update(store_params)
      redirect_to edit_admin_settings_path, notice: "Store settings updated successfully."
    else
      flash.now[:alert] = "There was a problem updating your settings."
      render :edit
    end
  end

  private

  def set_store
    @store = Current.store
  end

  def store_params
    params.require(:store).permit(:title, :description, :logo, :hero_image)
  end
end
