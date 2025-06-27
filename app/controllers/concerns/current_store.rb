module CurrentStore
  extend ActiveSupport::Concern

  included do
    before_action :set_current_store
  end

  private

  def set_current_store
    host = request.host
    subdomain = request.subdomains.first
    if subdomain.present?
      store = Store.find_by(subdomain: subdomain)
    else
      store = Store.joins(:custom_domain).find_by(custom_domains: { domain: host })
    end
    if store
      ActsAsTenant.current_tenant = store
      Current.store = store
    else
      ActsAsTenant.current_tenant = nil
      Current.store = nil
    end
  end
end
