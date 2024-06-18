class CreateSessionModules < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :session_logs, :module_lookups do |t|
      #t.index [:session_log_id, :module_lookup_id], unique: true
      #t.index [:module_lookup_id, :session_log_id], unique: true
    end
    create_table :session_modules do |t|
      t.references :session_log, null: false, foreign_key: true
      t.references :module_lookup, null: false, foreign_key: true

      t.timestamps
    end
  end
end
