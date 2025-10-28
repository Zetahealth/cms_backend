class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null


  enum :role, { user: "2", admin: "1" }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :assign_role

  private

  def assign_role
    update(role: "2") if role.blank?  # use string
  end


end
