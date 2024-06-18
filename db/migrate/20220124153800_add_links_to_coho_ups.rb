class AddLinksToCohoUps < ActiveRecord::Migration[6.1]
  def change
    add_column :coho_ups, :link_entry, :string
    add_column :coho_ups, :link_exit, :string
  end
end
