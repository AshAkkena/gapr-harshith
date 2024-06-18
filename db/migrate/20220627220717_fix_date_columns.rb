class FixDateColumns < ActiveRecord::Migration[6.1]
  def up
    remove_column :entry_surveys, :happened_on
    remove_column :exit_surveys, :happened_on
    add_column :entry_surveys, :happened_on, :date
    add_column :exit_surveys, :happened_on, :date
  end

  def down
    remove_column :entry_surveys, :happened_on
    remove_column :exit_surveys, :happened_on
    add_column :entry_surveys, :happened_on, :time
    add_column :exit_surveys, :happened_on, :time
  end
end
