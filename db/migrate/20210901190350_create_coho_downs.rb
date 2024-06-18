class CreateCohoDowns < ActiveRecord::Migration[6.1]
  def change
    create_table :coho_downs do |t|
      t.references :cohort, null: false, foreign_key: true
      t.integer :total_graduated_ms
      t.integer :total_graduated_hs
      t.integer :total_initiated_ms
      t.integer :total_initiated_hs
      t.integer :total_hours_delivered
      t.boolean :program_complete
      t.integer :census_foster
      t.integer :census_homeless
      t.integer :census_pregnant_parenting
      t.integer :census_adjudication
      t.string :main_setting
      t.boolean :covid_virtualization

      t.timestamps
    end
  end
end
