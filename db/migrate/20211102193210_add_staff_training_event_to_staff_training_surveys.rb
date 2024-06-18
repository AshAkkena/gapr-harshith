class AddStaffTrainingEventToStaffTrainingSurveys < ActiveRecord::Migration[6.1]
  def change
    add_reference :staff_training_surveys, :staff_training_event, null: false, foreign_key: true
  end
end
