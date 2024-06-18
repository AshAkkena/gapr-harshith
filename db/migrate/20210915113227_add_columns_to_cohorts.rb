class AddColumnsToCohorts < ActiveRecord::Migration[6.1]
  def change
    add_column :cohorts, :reliable_stat, :integer
    add_column :cohorts, :drift_stat, :integer
  end
end
