class AddColumnsToExitSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :exit_surveys, :lang_en, :boolean
    add_column :exit_surveys, :lang_sp, :boolean
    add_column :exit_surveys, :lang_other, :boolean
    add_column :exit_surveys, :race_indian, :boolean
    add_column :exit_surveys, :race_asian, :boolean
    add_column :exit_surveys, :race_black, :boolean
    add_column :exit_surveys, :race_pacific, :boolean
    add_column :exit_surveys, :race_white, :boolean
    add_column :exit_surveys, :race_other, :boolean
    add_column :exit_surveys, :lives_family, :boolean
    add_column :exit_surveys, :lives_foster_family, :boolean
    add_column :exit_surveys, :lives_foster_group, :boolean
    add_column :exit_surveys, :lives_couch, :boolean
    add_column :exit_surveys, :lives_outside, :boolean
    add_column :exit_surveys, :lives_shelter, :boolean
    add_column :exit_surveys, :lives_hotel, :boolean
    add_column :exit_surveys, :lives_jail, :boolean
    add_column :exit_surveys, :lives_none, :boolean
  end
end
