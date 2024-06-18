class AddSurveysToSessionLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :session_logs, :did_entry_survey, :boolean
    add_column :session_logs, :did_exit_survey, :boolean
  end
end
