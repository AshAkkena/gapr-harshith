class AddHappenedOnToExitSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :exit_surveys, :happened_on, :time
  end
end
