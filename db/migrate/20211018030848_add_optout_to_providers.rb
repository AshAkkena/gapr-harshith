class AddOptoutToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :using_optpout, :boolean
  end
end
