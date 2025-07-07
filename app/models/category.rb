class Category < ApplicationRecord
  acts_as_tenant(:store)

  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
