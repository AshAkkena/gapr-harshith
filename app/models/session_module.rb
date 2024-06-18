class SessionModule < ApplicationRecord
  belongs_to :session_log
  belongs_to :module_lookup
end
