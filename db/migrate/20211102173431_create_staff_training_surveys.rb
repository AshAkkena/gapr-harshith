class CreateStaffTrainingSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_training_surveys do |t|
      t.string :affiliation
      t.integer :quality_interest
      t.integer :quality_relevance
      t.integer :quality_will_use
      t.integer :quality_will_share
      t.integer :quality_will_recommend
      t.text :details_good
      t.text :details_improvement

      t.timestamps
    end
  end
end
