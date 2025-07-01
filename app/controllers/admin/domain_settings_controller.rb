class Admin::DomainSettingsController < Admin::BaseController
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
      flash[:error] = "Failed to update domain settings."
      redirect_to admin_domain_settings_path
    end
  end

  private

  def store
    Current.store
  end

  def custom_domain_params
    params.require(:store).require(:custom_domain_attributes).permit(:domain)
  end
end
