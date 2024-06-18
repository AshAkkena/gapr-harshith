class AddEnrollingToCohort < ActiveRecord::Migration[6.1]
  def change
    add_column :cohorts, :uses_enrollment, :boolean, default: false
  end
end
