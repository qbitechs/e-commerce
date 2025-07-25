class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :meta_tags, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
