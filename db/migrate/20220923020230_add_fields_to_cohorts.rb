class AddFieldsToCohorts < ActiveRecord::Migration[6.1]
  def change
    add_column :cohorts, :address, :string
    add_column :cohorts, :facilitator, :string
  end
end
