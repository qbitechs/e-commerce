class Store < ApplicationRecord
  has_one :custom_domain, dependent: :destroy
end
