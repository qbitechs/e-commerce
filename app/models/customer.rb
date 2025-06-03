class Customer < ApplicationRecord
  belongs_to :user
  has_one    :cart, dependent: :destroy
  has_many   :orders, dependent: :destroy

  after_create :create_cart
end
