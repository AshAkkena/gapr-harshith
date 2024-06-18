class Enrollment < ApplicationRecord
  belongs_to :cohort, optional: true
  has_many :enrollment_session_logs, dependent: :nullify
  has_many :session_logs, through: :enrollment_session_logs

  
  def quick_name
    "#{name_first}" + (name_pref.length > 0 ? " \"#{name_pref}\"" : "") + " #{name_last}"
  end

end
