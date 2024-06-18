class TuneEntrySurveys < ActiveRecord::Migration[6.1]
  def up
    change_column :entry_surveys, :lang_sp, :boolean, :default => false
    change_column :entry_surveys, :lang_en, :boolean, :default => false
    change_column :entry_surveys, :lang_other, :boolean, :default => false
    change_column :entry_surveys, :race_indian, :boolean, :default => false
    change_column :entry_surveys, :race_asian, :boolean, :default => false
    change_column :entry_surveys, :race_black, :boolean, :default => false
    change_column :entry_surveys, :race_pacific, :boolean, :default => false
    change_column :entry_surveys, :race_white, :boolean, :default => false
    change_column :entry_surveys, :race_other, :boolean, :default => false
    change_column :entry_surveys, :lives_family, :boolean, :default => false
    change_column :entry_surveys, :lives_foster_family, :boolean, :default => false
    change_column :entry_surveys, :lives_foster_group, :boolean, :default => false
    change_column :entry_surveys, :lives_couch, :boolean, :default => false
    change_column :entry_surveys, :lives_outside, :boolean, :default => false
    change_column :entry_surveys, :lives_shelter, :boolean, :default => false
    change_column :entry_surveys, :lives_hotel, :boolean, :default => false
    change_column :entry_surveys, :lives_jail, :boolean, :default => false
    change_column :entry_surveys, :lives_none, :boolean, :default => false
  end
  def down
  end
end
