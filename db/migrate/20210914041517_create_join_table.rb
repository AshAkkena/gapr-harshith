class CreateJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :session_logs, :module_lookups do |t|
      #t.index [:session_log_id, :module_lookup_id], unique: true
      #t.index [:module_lookup_id, :session_log_id], unique: true
    end
    remove_column :session_logs, :module_lookup_id
  end
end
