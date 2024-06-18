class AddVarietyToIncentives < ActiveRecord::Migration[6.1]
  def change
    add_column :incentives, :variety, :string
  end
end
