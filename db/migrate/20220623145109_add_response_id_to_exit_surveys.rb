class AddResponseIdToExitSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :exit_surveys, :response_id, :string
  end
end
