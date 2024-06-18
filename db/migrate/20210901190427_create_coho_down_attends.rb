class CreateCohoDownAttends < ActiveRecord::Migration[6.1]
  def change
    create_table :coho_down_attends do |t|
      t.references :cohort, null: false, foreign_key: true
      t.date :happened_on
      t.integer :middleschool_headcount
      t.integer :highschool_headcount
      t.integer :newface_ms_headcount
      t.integer :newface_hs_headcount

      t.timestamps
    end
  end
end
