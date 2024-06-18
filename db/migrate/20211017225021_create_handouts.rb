class CreateHandouts < ActiveRecord::Migration[6.1]
  def change
    create_table :handouts do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
