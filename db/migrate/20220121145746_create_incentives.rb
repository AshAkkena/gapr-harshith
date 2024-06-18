class CreateIncentives < ActiveRecord::Migration[6.1]
  def change
    create_table :incentives do |t|
      t.string :fingerprint
      t.decimal :period

      t.timestamps
    end
  end
end
