class CreateSessionLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :session_logs do |t|
      t.integer :period
      t.string :magic_code
      t.references :cohort, null: false, foreign_key: true
      t.date :happened_on
      t.integer :minutes_taught
      t.integer :middleschool_headcount
      t.integer :highschool_headcount
      t.integer :newface_ms_headcount
      t.integer :newface_hs_headcount
      t.string :facilitator_initial
      t.string :participantion_proportion
      t.string :interest_proportion
      t.string :enough_time
      t.boolean :taught_everything
      t.boolean :adapted_anything
      t.boolean :participant_referal
      t.string :impl_setting

      t.timestamps
    end
  end
end
