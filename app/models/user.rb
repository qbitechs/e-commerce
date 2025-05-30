class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :customer, dependent: :destroy
  has_one :admin,    dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,     presence: true, uniqueness: true

  after_create :build_role_profile

  enum :role, {
    customer: "customer",
    admin: "admin"
  }, default: :customer

  private

  def build_role_profile
    if admin?
      create_admin!
    else
      create_customer!
    end
  end
end
