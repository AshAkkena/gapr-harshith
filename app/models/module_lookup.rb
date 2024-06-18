class ModuleLookup < ApplicationRecord
  has_many :session_modules, dependent: :nullify
  has_many :session_logs, through: :session_modules
  
  def fancy_name
    "#{abbreviated_curriculum} #{delivery_sequence}: #{basic_name}"
  end
end
