class AddUniquenessToCohoDownAttends < ActiveRecord::Migration[6.1]
  def change
    add_index :coho_down_attends, [:cohort_id, :happened_on], unique: true
  end
end
