class EnrollmentSessionLog < ApplicationRecord
  belongs_to :enrollment
  belongs_to :session_log
  
end
