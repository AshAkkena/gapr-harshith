class AddNamesToCohort < ActiveRecord::Migration[6.1]
  def change
    add_column :cohorts, :name, :string
    add_column :cohorts, :extra_name, :string
  end
end
