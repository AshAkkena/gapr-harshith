class AddColumnsToCohoDowns < ActiveRecord::Migration[6.1]
  def change
    add_column :coho_downs, :ppr_count_male, :integer, default: 0
    add_column :coho_downs, :ppr_count_female, :integer, default: 0
    add_column :coho_downs, :ppr_count_10_13, :integer, default: 0
    add_column :coho_downs, :ppr_count_14_19, :integer, default: 0
    add_column :coho_downs, :ppr_count_20, :integer, default: 0
    add_column :coho_downs, :ppr_count_preg_par, :integer, default: 0
    add_column :coho_downs, :ppr_count_juv_jus, :integer, default: 0
    add_column :coho_downs, :ppr_count_foster, :integer, default: 0
    add_column :coho_downs, :ppr_count_runaway, :integer, default: 0
    add_column :coho_downs, :ppr_count_lgbt, :integer, default: 0
  end
end
