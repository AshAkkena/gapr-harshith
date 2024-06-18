class CreateStaffTrainingEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_training_events do |t|
      t.string :training_name
      t.date :training_date
      t.string :training_place
      t.string :training_trainer
      t.integer :period, :decimal, precision: 5, scale: 1

      t.timestamps
    end
  end
end
