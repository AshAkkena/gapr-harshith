class AddPercepInterestToExitSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :exit_surveys, :percep_interest, :integer
  end
end
