class AddDemographicsToEnrollments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrollments, :age, :numeric
    add_column :enrollments, :gender_m, :boolean
    add_column :enrollments, :gender_f, :boolean
    add_column :enrollments, :gender_o, :boolean
    add_column :enrollments, :gender_n, :boolean
    add_column :enrollments, :race_wh, :boolean
    add_column :enrollments, :race_bl, :boolean
    add_column :enrollments, :race_in, :boolean
    add_column :enrollments, :race_as, :boolean
    add_column :enrollments, :race_hw, :boolean
    add_column :enrollments, :race_or, :boolean
    add_column :enrollments, :race_no, :boolean
    add_column :enrollments, :race_es, :boolean
    add_column :enrollments, :lgbt, :boolean
    add_column :enrollments, :preg_par, :boolean
  end
end
