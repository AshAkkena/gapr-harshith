class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :entry_surveys, :bevhaior_alcohol, :behavior_alcohol
  end
end
