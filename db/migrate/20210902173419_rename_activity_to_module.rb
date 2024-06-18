class RenameActivityToModule < ActiveRecord::Migration[6.1]
  def change
    rename_table :activity_lookups, :module_lookups
  end
end
