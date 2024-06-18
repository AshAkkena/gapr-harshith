class AddIndexToSessionLogs < ActiveRecord::Migration[6.1]
  def change
    add_index :session_logs, [:cohort_id, :happened_on], unique: true
  end
end
