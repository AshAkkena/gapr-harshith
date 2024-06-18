class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :managed_providers, -> { where(roles: {name: :site_admin}) }, through: :roles, source: :resource, source_type:  :Provider
  has_many :filters
  
  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    "inactive"
  end

end
