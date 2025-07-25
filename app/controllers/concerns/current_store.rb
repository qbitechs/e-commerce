module CurrentStore
  extend ActiveSupport::Concern

  included do
    before_action :set_current_store
  end

  private

  def set_current_store
    store = store_by_host || store_by_session || current_user_store

    if store
      ActsAsTenant.current_tenant = store
      Current.store = store
      session[:store_id] = store.id
    else
      ActsAsTenant.current_tenant = nil
      Current.store = nil
      session[:store_id] = nil
    end
  end

  def store_by_host
    host = request.host
    subdomain = request.subdomains.first

    if host.include?("localhost")
      subdomain = host.split(".").first
    end

    if subdomain.present?
      Store.find_by(subdomain: subdomain)
    else
      Store.joins(:custom_domain).find_by(custom_domains: { domain: host })
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_user_store
    return nil unless Current.session&.user

    Current.session.user.stores.first
  end

  def store_by_session
    return nil unless session[:store_id]

    Store.find_by(id: session[:store_id])
  end
end
