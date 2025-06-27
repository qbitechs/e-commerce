class Customer < ApplicationRecord
  belongs_to :store

  # ToDo Customer donot delete, soft delete
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  after_create :create_cart

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def create_cart
    create_cart!
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "email", "first_name", "last_name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
