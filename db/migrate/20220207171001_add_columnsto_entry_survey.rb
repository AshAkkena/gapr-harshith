class AddColumnstoEntrySurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :entry_surveys, :screen_grade, :numeric
    add_column :exit_surveys, :screen_grade, :numeric
  end
end
