class CreateEnrollmentSessionLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollment_session_logs do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.references :session_log, null: false, foreign_key: true

      t.timestamps
    end
  end
end
