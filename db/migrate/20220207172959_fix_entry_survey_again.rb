class FixEntrySurveyAgain < ActiveRecord::Migration[6.1]
  def up
      change_column :entry_surveys, :screen_grade, :integer, default: 0
  end
  def down
  end
end
