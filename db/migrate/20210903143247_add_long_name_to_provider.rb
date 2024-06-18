class AddLongNameToProvider < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :long_name, :string
  end
end
