class CreateCohoUps < ActiveRecord::Migration[6.1]
  def change
    create_table :coho_ups do |t|
      t.references :cohort, null: false, foreign_key: true
      t.string :magic_code

      t.timestamps
    end
  end
end
