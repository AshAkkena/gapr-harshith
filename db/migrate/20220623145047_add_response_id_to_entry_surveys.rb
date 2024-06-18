class AddResponseIdToEntrySurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :entry_surveys, :response_id, :string
  end
end
