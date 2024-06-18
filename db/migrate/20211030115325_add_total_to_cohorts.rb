class AddTotalToCohorts < ActiveRecord::Migration[6.1]
  def change
    add_column :coho_ups, :ppr_count_total, :integer, default: 0
    add_column :coho_downs, :ppr_count_total, :integer, default: 0
  end
end
