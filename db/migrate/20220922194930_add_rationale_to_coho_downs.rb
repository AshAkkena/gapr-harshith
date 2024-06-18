class AddRationaleToCohoDowns < ActiveRecord::Migration[6.1]
  def change
    add_column :coho_downs, :rationale, :string
  end
end
