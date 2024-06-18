class AddModuleLookupToSessionLogs < ActiveRecord::Migration[6.1]
  def change
    add_reference :session_logs, :module_lookup, null: false, foreign_key: true
  end
end
