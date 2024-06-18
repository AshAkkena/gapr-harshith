class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.references :cohort
      t.string :name_first
      t.string :name_pref
      t.string :name_last
      t.boolean :needs_perm
      t.boolean :perm_prog
      t.boolean :perm_surveys
      t.boolean :trashed, default: false

      t.timestamps
    end
  end
end
