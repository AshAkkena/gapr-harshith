class AddGraduateToEnrollments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrollments, :graduate, :boolean, default: false
  end
end
