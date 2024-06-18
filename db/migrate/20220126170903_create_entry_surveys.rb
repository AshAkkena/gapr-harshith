class CreateEntrySurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :entry_surveys do |t|
      t.string :magic
      t.string :contractor
      t.string :cohort
      t.string :curriculum
      t.string :h_age
      t.string :h_grade
      t.string :m_age
      t.string :m_grade
      t.boolean :lang_sp
      t.boolean :lang_en
      t.boolean :lang_other
      t.string :lang_other_txt
      t.boolean :is_hispanic
      t.boolean :race_indian
      t.boolean :race_asian
      t.boolean :race_black
      t.boolean :race_pacific
      t.boolean :race_white
      t.boolean :race_other
      t.string :race_other_txt
      t.boolean :is_male
      t.boolean :lives_family
      t.boolean :lives_foster_family
      t.boolean :lives_foster_group
      t.boolean :lives_couch
      t.boolean :lives_outside
      t.boolean :lives_shelter
      t.boolean :lives_hotel
      t.boolean :lives_jail
      t.boolean :lives_none
      t.string :behavior_peer
      t.string :behavior_emotion
      t.string :bevhaior_alcohol
      t.string :behavior_think
      t.string :intent_plans
      t.string :intent_study
      t.string :intent_graduate
      t.string :intent_more_study
      t.string :intent_work
      t.string :intent_speakup_self
      t.string :intent_speakup_others
      t.string :finance_save
      t.string :finance_bank
      t.string :finance_budget
      t.string :finance_track
      t.string :finance_cost
      t.string :talk_parent
      t.string :talk_other
      t.string :relate_healthy
      t.string :relate_info
      t.string :relate_resist
      t.string :relate_talk
      t.boolean :hadsex
      t.string :num_partners
      t.string :condom
      t.string :contraceptive
      t.string :preg
      t.string :sti
      t.string :sexintent_delaysex_hs
      t.string :sexintent_delaysex_college
      t.string :sexintent_delaysex_marry
      t.string :sexintent_delaykid_marry
      t.string :sexintent_delaymarry_work
      t.string :sexintent_delaychild_work

      t.timestamps
    end
  end
end
