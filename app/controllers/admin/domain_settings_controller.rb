class Admin::DomainSettingsController < Admin::ApplicationController
  def show
    @store = store
  end

  def edit
    @store = store
  end

  def update
    domain_type = params[:store][:domain_type]
    if domain_type == "subdomain"
      store.subdomain = params[:store][:subdomain]
      store.custom_domain&.destroy
    elsif domain_type == "custom"
      store.subdomain = nil
      if store.custom_domain
        store.custom_domain.update(custom_domain_params)
      else
        store.create_custom_domain(custom_domain_params)
      end
    end

    if store.save
      flash[:success] = "Domain settings updated successfully."
      redirect_to admin_domain_settings_path
    else
      @store = store
      flash.now[:error] = "Failed to update domain settings."
      render :show
    end
  end

  private

  def store
    Current.store
  end

  def custom_domain_params
    params.require(:store).permit(custom_domain_attributes: [ :domain ])
  end
end
