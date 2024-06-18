class FixCohoDownAttendsReferences < ActiveRecord::Migration[6.1]
  def change
    remove_reference :coho_down_attends, :cohort, null: false, foreign_key: true
    add_reference :coho_down_attends, :coho_down, null: false, index: true, foreign_key: true
  end
end
