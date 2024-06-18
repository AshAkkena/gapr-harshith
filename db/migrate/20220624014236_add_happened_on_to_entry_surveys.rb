class AddHappenedOnToEntrySurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :entry_surveys, :happened_on, :time
  end
end
