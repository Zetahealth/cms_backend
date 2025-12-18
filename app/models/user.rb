class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable,
         :registerable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null


  enum :role, { user: "2", admin: "1" }
  enum :permission, { editor: "2", viewer: "1" }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :assign_role
  # has_many :user_logs
  has_many :user_logs, dependent: :destroy

  private

  def assign_role
    update(role: "2") if role.blank?  # use string
  end


end
