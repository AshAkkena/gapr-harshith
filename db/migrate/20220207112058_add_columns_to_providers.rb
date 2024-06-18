class AddColumnsToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :is_test, :boolean, default: false
    add_column :providers, :can_pool, :boolean, default: false
  end
end
