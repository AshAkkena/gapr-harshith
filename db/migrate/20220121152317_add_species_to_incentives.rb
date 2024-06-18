class AddSpeciesToIncentives < ActiveRecord::Migration[6.1]
  def change
    add_column :incentives, :species, :string
  end
end
