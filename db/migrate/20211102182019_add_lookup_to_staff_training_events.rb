class AddLookupToStaffTrainingEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :staff_training_events, :lookup, :string
  end
end
