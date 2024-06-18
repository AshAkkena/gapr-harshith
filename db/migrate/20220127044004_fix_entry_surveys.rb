class FixEntrySurveys < ActiveRecord::Migration[6.1]
  def self.up
    remove_column :entry_surveys, :h_age 
    remove_column :entry_surveys, :h_grade 
    remove_column :entry_surveys, :m_age 
    remove_column :entry_surveys, :m_grade 
    remove_column :entry_surveys, :is_hispanic 
    remove_column :entry_surveys, :is_male 
    remove_column :entry_surveys, :behavior_peer 
    remove_column :entry_surveys, :behavior_emotion 
    remove_column :entry_surveys, :bevhaior_alcohol 
    remove_column :entry_surveys, :behavior_think 
    remove_column :entry_surveys, :intent_plans 
    remove_column :entry_surveys, :intent_study 
    remove_column :entry_surveys, :intent_graduate 
    remove_column :entry_surveys, :intent_more_study 
    remove_column :entry_surveys, :intent_work 
    remove_column :entry_surveys, :intent_speakup_self 
    remove_column :entry_surveys, :intent_speakup_others 
    remove_column :entry_surveys, :finance_save 
    remove_column :entry_surveys, :finance_bank 
    remove_column :entry_surveys, :finance_budget 
    remove_column :entry_surveys, :finance_track 
    remove_column :entry_surveys, :finance_cost 
    remove_column :entry_surveys, :talk_parent 
    remove_column :entry_surveys, :talk_other 
    remove_column :entry_surveys, :relate_healthy 
    remove_column :entry_surveys, :relate_info 
    remove_column :entry_surveys, :relate_resist 
    remove_column :entry_surveys, :relate_talk 
    remove_column :entry_surveys, :hadsex 
    remove_column :entry_surveys, :num_partners 
    remove_column :entry_surveys, :condom 
    remove_column :entry_surveys, :contraceptive 
    remove_column :entry_surveys, :preg 
    remove_column :entry_surveys, :sti 
    remove_column :entry_surveys, :sexintent_delaysex_hs 
    remove_column :entry_surveys, :sexintent_delaysex_college 
    remove_column :entry_surveys, :sexintent_delaysex_marry 
    remove_column :entry_surveys, :sexintent_delaykid_marry 
    remove_column :entry_surveys, :sexintent_delaymarry_work 
    remove_column :entry_surveys, :sexintent_delaychild_work 
  
    add_column :entry_surveys, :h_age, :integer, default: 0 
    add_column :entry_surveys, :h_grade, :integer, default: 0 
    add_column :entry_surveys, :m_age, :integer, default: 0 
    add_column :entry_surveys, :m_grade, :integer, default: 0 
    add_column :entry_surveys, :is_hispanic, :integer, default: 0 
    add_column :entry_surveys, :is_male, :integer, default: 0 
    add_column :entry_surveys, :behavior_peer, :integer, default: 0 
    add_column :entry_surveys, :behavior_emotion, :integer, default: 0 
    add_column :entry_surveys, :bevhaior_alcohol, :integer, default: 0 
    add_column :entry_surveys, :behavior_think, :integer, default: 0 
    add_column :entry_surveys, :intent_plans, :integer, default: 0 
    add_column :entry_surveys, :intent_study, :integer, default: 0 
    add_column :entry_surveys, :intent_graduate, :integer, default: 0 
    add_column :entry_surveys, :intent_more_study, :integer, default: 0 
    add_column :entry_surveys, :intent_work, :integer, default: 0 
    add_column :entry_surveys, :intent_speakup_self, :integer, default: 0 
    add_column :entry_surveys, :intent_speakup_others, :integer, default: 0 
    add_column :entry_surveys, :finance_save, :integer, default: 0 
    add_column :entry_surveys, :finance_bank, :integer, default: 0 
    add_column :entry_surveys, :finance_budget, :integer, default: 0 
    add_column :entry_surveys, :finance_track, :integer, default: 0 
    add_column :entry_surveys, :finance_cost, :integer, default: 0 
    add_column :entry_surveys, :talk_parent, :integer, default: 0 
    add_column :entry_surveys, :talk_other, :integer, default: 0 
    add_column :entry_surveys, :relate_healthy, :integer, default: 0 
    add_column :entry_surveys, :relate_info, :integer, default: 0 
    add_column :entry_surveys, :relate_resist, :integer, default: 0 
    add_column :entry_surveys, :relate_talk, :integer, default: 0 
    add_column :entry_surveys, :hadsex, :integer, default: 0 
    add_column :entry_surveys, :num_partners, :integer, default: 0 
    add_column :entry_surveys, :condom, :integer, default: 0 
    add_column :entry_surveys, :contraceptive, :integer, default: 0 
    add_column :entry_surveys, :preg, :integer, default: 0 
    add_column :entry_surveys, :sti, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaysex_hs, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaysex_college, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaysex_marry, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaykid_marry, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaymarry_work, :integer, default: 0 
    add_column :entry_surveys, :sexintent_delaychild_work, :integer, default: 0 
  end
  def self.down
    remove_column :entry_surveys, :h_age 
    remove_column :entry_surveys, :h_grade 
    remove_column :entry_surveys, :m_age 
    remove_column :entry_surveys, :m_grade 
    remove_column :entry_surveys, :is_hispanic 
    remove_column :entry_surveys, :is_male 
    remove_column :entry_surveys, :behavior_peer 
    remove_column :entry_surveys, :behavior_emotion 
    remove_column :entry_surveys, :bevhaior_alcohol 
    remove_column :entry_surveys, :behavior_think 
    remove_column :entry_surveys, :intent_plans 
    remove_column :entry_surveys, :intent_study 
    remove_column :entry_surveys, :intent_graduate 
    remove_column :entry_surveys, :intent_more_study 
    remove_column :entry_surveys, :intent_work 
    remove_column :entry_surveys, :intent_speakup_self 
    remove_column :entry_surveys, :intent_speakup_others 
    remove_column :entry_surveys, :finance_save 
    remove_column :entry_surveys, :finance_bank 
    remove_column :entry_surveys, :finance_budget 
    remove_column :entry_surveys, :finance_track 
    remove_column :entry_surveys, :finance_cost 
    remove_column :entry_surveys, :talk_parent 
    remove_column :entry_surveys, :talk_other 
    remove_column :entry_surveys, :relate_healthy 
    remove_column :entry_surveys, :relate_info 
    remove_column :entry_surveys, :relate_resist 
    remove_column :entry_surveys, :relate_talk 
    remove_column :entry_surveys, :hadsex 
    remove_column :entry_surveys, :num_partners 
    remove_column :entry_surveys, :condom 
    remove_column :entry_surveys, :contraceptive 
    remove_column :entry_surveys, :preg 
    remove_column :entry_surveys, :sti 
    remove_column :entry_surveys, :sexintent_delaysex_hs 
    remove_column :entry_surveys, :sexintent_delaysex_college 
    remove_column :entry_surveys, :sexintent_delaysex_marry 
    remove_column :entry_surveys, :sexintent_delaykid_marry 
    remove_column :entry_surveys, :sexintent_delaymarry_work 
    remove_column :entry_surveys, :sexintent_delaychild_work 
  
    add_column :entry_surveys, :h_age, :string
    add_column :entry_surveys, :h_grade, :string
    add_column :entry_surveys, :m_age, :string
    add_column :entry_surveys, :m_grade, :string
    add_column :entry_surveys, :is_hispanic, :boolean
    add_column :entry_surveys, :is_male, :boolean
    add_column :entry_surveys, :lives_family, :boolean
    add_column :entry_surveys, :lives_foster_family, :boolean
    add_column :entry_surveys, :lives_foster_group, :boolean
    add_column :entry_surveys, :lives_couch, :boolean
    add_column :entry_surveys, :lives_outside, :boolean
    add_column :entry_surveys, :lives_shelter, :boolean
    add_column :entry_surveys, :lives_hotel, :boolean
    add_column :entry_surveys, :lives_jail, :boolean
    add_column :entry_surveys, :lives_none, :boolean
    add_column :entry_surveys, :behavior_peer, :string
    add_column :entry_surveys, :behavior_emotion, :string
    add_column :entry_surveys, :bevhaior_alcohol, :string
    add_column :entry_surveys, :behavior_think, :string
    add_column :entry_surveys, :intent_plans, :string
    add_column :entry_surveys, :intent_study, :string
    add_column :entry_surveys, :intent_graduate, :string
    add_column :entry_surveys, :intent_more_study, :string
    add_column :entry_surveys, :intent_work, :string
    add_column :entry_surveys, :intent_speakup_self, :string
    add_column :entry_surveys, :intent_speakup_others, :string
    add_column :entry_surveys, :finance_save, :string
    add_column :entry_surveys, :finance_bank, :string
    add_column :entry_surveys, :finance_budget, :string
    add_column :entry_surveys, :finance_track, :string
    add_column :entry_surveys, :finance_cost, :string
    add_column :entry_surveys, :talk_parent, :string
    add_column :entry_surveys, :talk_other, :string
    add_column :entry_surveys, :relate_healthy, :string
    add_column :entry_surveys, :relate_info, :string
    add_column :entry_surveys, :relate_resist, :string
    add_column :entry_surveys, :relate_talk, :string
    add_column :entry_surveys, :hadsex, :boolean
    add_column :entry_surveys, :num_partners, :string
    add_column :entry_surveys, :condom, :string
    add_column :entry_surveys, :contraceptive, :string
    add_column :entry_surveys, :preg, :string
    add_column :entry_surveys, :sti, :string
    add_column :entry_surveys, :sexintent_delaysex_hs, :string
    add_column :entry_surveys, :sexintent_delaysex_college, :string
    add_column :entry_surveys, :sexintent_delaysex_marry, :string
    add_column :entry_surveys, :sexintent_delaykid_marry, :string
    add_column :entry_surveys, :sexintent_delaymarry_work, :string
    add_column :entry_surveys, :sexintent_delaychild_work, :string
  end
end
