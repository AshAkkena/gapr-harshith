class CreateActivityLookups < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_lookups do |t|
      t.integer :period
      t.string :abbreviated_curriculum
      t.integer :delivery_sequence
      t.string :basic_name

      t.timestamps
    end
  end
end
