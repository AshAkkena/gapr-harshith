class AddIndexToVersions < ActiveRecord::Migration[6.1]
  def change
    add_index :versions, :created_at
  end
end
