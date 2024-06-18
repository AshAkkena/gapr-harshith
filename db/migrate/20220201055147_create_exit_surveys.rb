class CreateExitSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :exit_surveys do |t|
      t.string :magic
      t.string :contractor
      t.string :cohort
      t.string :curriculum
      t.numeric :h_age
      t.numeric :h_grade
      t.numeric :m_age
      t.numeric :m_grade
      t.numeric :lang
      t.string :lang_other_txt
      t.numeric :is_hispanic
      t.numeric :race
      t.string :race_other_txt
      t.numeric :is_male
      t.numeric :domestic
      t.numeric :impact_behavior_peer
      t.numeric :impact_behavior_emotion
      t.numeric :impact_behavior_alcohol
      t.numeric :impact_behavior_think
      t.numeric :impact_intent_plans
      t.numeric :impact_intent_study
      t.numeric :impact_intent_graduate
      t.numeric :impact_intent_more_study
      t.numeric :impact_intent_work
      t.numeric :impact_finance_save
      t.numeric :impact_finance_bank
      t.numeric :impact_finance_budget
      t.numeric :impact_finance_track
      t.numeric :impact_finance_cost
      t.numeric :impact_talk_parent
      t.numeric :impact_talk_other
      t.numeric :impact_relate_healthy
      t.numeric :impact_relate_resist
      t.numeric :impact_relate_talk
      t.numeric :plan_abstainsex
      t.numeric :abstain_yes_plans
      t.numeric :abstain_yes_consequences
      t.numeric :abstain_yes_sti
      t.numeric :abstain_yes_preg
      t.numeric :abstain_notyes_havesex
      t.numeric :abstain_notyes_condom
      t.numeric :abstain_notyes_contra
      t.numeric :percep_clear
      t.numeric :percep_learn
      t.numeric :percep_ask
      t.numeric :percep_respect
      t.numeric :satisfaction_abstain
      t.numeric :satisfaction_contra

      t.timestamps
    end
  end
end
