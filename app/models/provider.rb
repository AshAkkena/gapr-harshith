class Provider < ApplicationRecord
  has_many :cohort
  has_paper_trail
  resourcify
  
  has_many :coho_ups, through: :cohort
  has_many :coho_downs, through: :cohort
  has_many :enrollments, through: :cohort
  
  has_many :entry_surveys, through: :cohort
  has_many :exit_surveys, through: :cohort
  
  has_many :site_admins, -> { where(roles: {name: :site_admin}) }, through: :roles, class_name: 'User', source: :users
  
  has_many :filters
  
end
