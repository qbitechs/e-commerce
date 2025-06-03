class Customer < ApplicationRecord
  belongs_to :user
  has_one    :cart
  has_many   :orders, dependent: :destroy
end
