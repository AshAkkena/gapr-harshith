class CreateCohorts < ActiveRecord::Migration[6.1]
  def change
    create_table :cohorts do |t|
      t.integer :period
      t.references :provider, null: false, foreign_key: true
      t.string :curriculum_choice
      t.date :intended_start
      t.date :intended_finish
      t.integer :intended_session_count
      t.integer :intended_session_duration_minute
      t.string :intended_setting
      t.boolean :target_foster
      t.boolean :target_homeless_runaway
      t.boolean :target_hiv_aids
      t.boolean :target_pregnant_parenting
      t.boolean :target_latino
      t.boolean :target_african_american
      t.boolean :target_native_american
      t.boolean :target_adjudicated
      t.boolean :target_male
      t.boolean :target_highneed_geo
      t.boolean :target_dropout
      t.boolean :target_mental_health
      t.boolean :target_trafficked
      t.boolean :covered_healthy_relationship
      t.boolean :healthy_relationship_material_evidence_based
      t.boolean :healthy_relationship_material_add_curr_entirely
      t.boolean :healthy_relationship_material_add_curr_adhoc
      t.boolean :healthy_relationship_material_original_content
      t.boolean :covered_adolescent_development
      t.boolean :adolescent_development_material_evidence_based
      t.boolean :adolescent_development_material_add_curr_entirely
      t.boolean :adolescent_development_material_add_curr_adhoc
      t.boolean :adolescent_development_material_original_content
      t.boolean :covered_financial_literacy
      t.boolean :financial_literacy_material_evidence_based
      t.boolean :financial_literacy_material_add_curr_entirely
      t.boolean :financial_literacy_material_add_curr_adhoc
      t.boolean :financial_literacy_material_original_content
      t.boolean :covered_par_child_comm
      t.boolean :par_child_comm_material_evidence_based
      t.boolean :par_child_comm_material_add_curr_entirely
      t.boolean :par_child_comm_material_add_curr_adhoc
      t.boolean :par_child_comm_material_original_content
      t.boolean :covered_edu_career_success
      t.boolean :edu_career_success_material_evidence_based
      t.boolean :edu_career_success_material_add_curr_entirely
      t.boolean :edu_career_success_material_add_curr_adhoc
      t.boolean :edu_career_success_material_original_content
      t.boolean :covered_healthy_life_skills
      t.boolean :healthy_life_skills_material_evidence_based
      t.boolean :healthy_life_skills_material_add_curr_entirely
      t.boolean :healthy_life_skills_material_add_curr_adhoc
      t.boolean :healthy_life_skills_material_original_content

      t.timestamps
    end
  end
end
