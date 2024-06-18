class FixExitSurveys < ActiveRecord::Migration[6.1]
  def up
    change_column :exit_surveys, :h_age, :integer, default: 0
    change_column :exit_surveys, :h_grade, :integer, default: 0
    change_column :exit_surveys, :m_age, :integer, default: 0
    change_column :exit_surveys, :m_grade, :integer, default: 0
    change_column :exit_surveys, :lang, :integer, default: 0
    change_column :exit_surveys, :is_hispanic, :integer, default: 0
    change_column :exit_surveys, :race, :integer, default: 0
    change_column :exit_surveys, :is_male, :integer, default: 0
    change_column :exit_surveys, :domestic, :integer, default: 0
    change_column :exit_surveys, :impact_behavior_peer, :integer, default: 0
    change_column :exit_surveys, :impact_behavior_emotion, :integer, default: 0
    change_column :exit_surveys, :impact_behavior_alcohol, :integer, default: 0
    change_column :exit_surveys, :impact_behavior_think, :integer, default: 0
    change_column :exit_surveys, :impact_intent_plans, :integer, default: 0
    change_column :exit_surveys, :impact_intent_study, :integer, default: 0
    change_column :exit_surveys, :impact_intent_graduate, :integer, default: 0
    change_column :exit_surveys, :impact_intent_more_study, :integer, default: 0
    change_column :exit_surveys, :impact_intent_work, :integer, default: 0
    change_column :exit_surveys, :impact_finance_save, :integer, default: 0
    change_column :exit_surveys, :impact_finance_bank, :integer, default: 0
    change_column :exit_surveys, :impact_finance_budget, :integer, default: 0
    change_column :exit_surveys, :impact_finance_track, :integer, default: 0
    change_column :exit_surveys, :impact_finance_cost, :integer, default: 0
    change_column :exit_surveys, :impact_talk_parent, :integer, default: 0
    change_column :exit_surveys, :impact_talk_other, :integer, default: 0
    change_column :exit_surveys, :impact_relate_healthy, :integer, default: 0
    change_column :exit_surveys, :impact_relate_resist, :integer, default: 0
    change_column :exit_surveys, :impact_relate_talk, :integer, default: 0
    change_column :exit_surveys, :plan_abstainsex, :integer, default: 0
    change_column :exit_surveys, :abstain_yes_plans, :integer, default: 0
    change_column :exit_surveys, :abstain_yes_consequences, :integer, default: 0
    change_column :exit_surveys, :abstain_yes_sti, :integer, default: 0
    change_column :exit_surveys, :abstain_yes_preg, :integer, default: 0
    change_column :exit_surveys, :abstain_notyes_havesex, :integer, default: 0
    change_column :exit_surveys, :abstain_notyes_condom, :integer, default: 0
    change_column :exit_surveys, :abstain_notyes_contra, :integer, default: 0
    change_column :exit_surveys, :percep_clear, :integer, default: 0
    change_column :exit_surveys, :percep_learn, :integer, default: 0
    change_column :exit_surveys, :percep_ask, :integer, default: 0
    change_column :exit_surveys, :percep_respect, :integer, default: 0
    change_column :exit_surveys, :satisfaction_abstain, :integer, default: 0
    change_column :exit_surveys, :satisfaction_contra, :integer, default: 0
    change_column :exit_surveys, :screen_grade, :integer, default: 0
  end
  def down
  end
end
