class AddDoneToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :done, :boolean, default: false
  end
end
