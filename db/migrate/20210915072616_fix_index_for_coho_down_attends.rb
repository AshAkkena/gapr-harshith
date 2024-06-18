class FixIndexForCohoDownAttends < ActiveRecord::Migration[6.1]
  def change
    add_index :coho_down_attends, [:coho_down_id, :happened_on], unique: true
  end
end
