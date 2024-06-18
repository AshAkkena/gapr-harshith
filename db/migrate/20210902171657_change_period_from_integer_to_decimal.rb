class ChangePeriodFromIntegerToDecimal < ActiveRecord::Migration[6.1]
  def change
    change_column :grantees, :period, :decimal, precision: 5, scale: 1
    change_column :cohorts, :period, :decimal, precision: 5, scale: 1
    change_column :activity_lookups, :period, :decimal, precision: 5, scale: 1
    change_column :session_logs, :period, :decimal, precision: 5, scale: 1
    change_column :providers, :period, :decimal, precision: 5, scale: 1
  end
end
