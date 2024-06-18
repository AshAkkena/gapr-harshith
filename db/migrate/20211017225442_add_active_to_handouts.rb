class AddActiveToHandouts < ActiveRecord::Migration[6.1]
  def change
    add_column :handouts, :active, :boolean
  end
end
