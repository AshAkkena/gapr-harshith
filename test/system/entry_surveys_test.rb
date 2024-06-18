require "application_system_test_case"

class EntrySurveysTest < ApplicationSystemTestCase
  setup do
    @entry_survey = entry_surveys(:one)
  end

  test "visiting the index" do
    visit entry_surveys_url
    assert_selector "h1", text: "Entry Surveys"
  end

  test "creating a Entry survey" do
    visit entry_surveys_url
    click_on "New Entry Survey"

    fill_in "Behavior emotion", with: @entry_survey.behavior_emotion
    fill_in "Behavior peer", with: @entry_survey.behavior_peer
    fill_in "Behavior think", with: @entry_survey.behavior_think
    fill_in "Bevhaior alcohol", with: @entry_survey.bevhaior_alcohol
    fill_in "Cohort", with: @entry_survey.cohort
    fill_in "Condom", with: @entry_survey.condom
    fill_in "Contraceptive", with: @entry_survey.contraceptive
    fill_in "Contractor", with: @entry_survey.contractor
    fill_in "Curriculum", with: @entry_survey.curriculum
    fill_in "Finance bank", with: @entry_survey.finance_bank
    fill_in "Finance budget", with: @entry_survey.finance_budget
    fill_in "Finance cost", with: @entry_survey.finance_cost
    fill_in "Finance save", with: @entry_survey.finance_save
    fill_in "Finance track", with: @entry_survey.finance_track
    fill_in "H age", with: @entry_survey.h_age
    fill_in "H grade", with: @entry_survey.h_grade
    check "Hadsex" if @entry_survey.hadsex
    fill_in "Intent graduate", with: @entry_survey.intent_graduate
    fill_in "Intent more study", with: @entry_survey.intent_more_study
    fill_in "Intent plans", with: @entry_survey.intent_plans
    fill_in "Intent speakup others", with: @entry_survey.intent_speakup_others
    fill_in "Intent speakup self", with: @entry_survey.intent_speakup_self
    fill_in "Intent study", with: @entry_survey.intent_study
    fill_in "Intent work", with: @entry_survey.intent_work
    check "Is hispanic" if @entry_survey.is_hispanic
    check "Is male" if @entry_survey.is_male
    check "Lang en" if @entry_survey.lang_en
    check "Lang other" if @entry_survey.lang_other
    fill_in "Lang other txt", with: @entry_survey.lang_other_txt
    check "Lang sp" if @entry_survey.lang_sp
    check "Lives couch" if @entry_survey.lives_couch
    check "Lives family" if @entry_survey.lives_family
    check "Lives foster family" if @entry_survey.lives_foster_family
    check "Lives foster group" if @entry_survey.lives_foster_group
    check "Lives hotel" if @entry_survey.lives_hotel
    check "Lives jail" if @entry_survey.lives_jail
    check "Lives none" if @entry_survey.lives_none
    check "Lives outside" if @entry_survey.lives_outside
    check "Lives shelter" if @entry_survey.lives_shelter
    fill_in "M age", with: @entry_survey.m_age
    fill_in "M grade", with: @entry_survey.m_grade
    fill_in "Magic", with: @entry_survey.magic
    fill_in "Num partners", with: @entry_survey.num_partners
    fill_in "Preg", with: @entry_survey.preg
    check "Race asian" if @entry_survey.race_asian
    check "Race black" if @entry_survey.race_black
    check "Race indian" if @entry_survey.race_indian
    check "Race other" if @entry_survey.race_other
    fill_in "Race other txt", with: @entry_survey.race_other_txt
    check "Race pacific" if @entry_survey.race_pacific
    check "Race white" if @entry_survey.race_white
    fill_in "Relate healthy", with: @entry_survey.relate_healthy
    fill_in "Relate info", with: @entry_survey.relate_info
    fill_in "Relate resist", with: @entry_survey.relate_resist
    fill_in "Relate talk", with: @entry_survey.relate_talk
    fill_in "Sexintent delaychild work", with: @entry_survey.sexintent_delaychild_work
    fill_in "Sexintent delaykid marry", with: @entry_survey.sexintent_delaykid_marry
    fill_in "Sexintent delaymarry work", with: @entry_survey.sexintent_delaymarry_work
    fill_in "Sexintent delaysex college", with: @entry_survey.sexintent_delaysex_college
    fill_in "Sexintent delaysex hs", with: @entry_survey.sexintent_delaysex_hs
    fill_in "Sexintent delaysex marry", with: @entry_survey.sexintent_delaysex_marry
    fill_in "Sti", with: @entry_survey.sti
    fill_in "Talk other", with: @entry_survey.talk_other
    fill_in "Talk parent", with: @entry_survey.talk_parent
    click_on "Create Entry survey"

    assert_text "Entry survey was successfully created"
    click_on "Back"
  end

  test "updating a Entry survey" do
    visit entry_surveys_url
    click_on "Edit", match: :first

    fill_in "Behavior emotion", with: @entry_survey.behavior_emotion
    fill_in "Behavior peer", with: @entry_survey.behavior_peer
    fill_in "Behavior think", with: @entry_survey.behavior_think
    fill_in "Bevhaior alcohol", with: @entry_survey.bevhaior_alcohol
    fill_in "Cohort", with: @entry_survey.cohort
    fill_in "Condom", with: @entry_survey.condom
    fill_in "Contraceptive", with: @entry_survey.contraceptive
    fill_in "Contractor", with: @entry_survey.contractor
    fill_in "Curriculum", with: @entry_survey.curriculum
    fill_in "Finance bank", with: @entry_survey.finance_bank
    fill_in "Finance budget", with: @entry_survey.finance_budget
    fill_in "Finance cost", with: @entry_survey.finance_cost
    fill_in "Finance save", with: @entry_survey.finance_save
    fill_in "Finance track", with: @entry_survey.finance_track
    fill_in "H age", with: @entry_survey.h_age
    fill_in "H grade", with: @entry_survey.h_grade
    check "Hadsex" if @entry_survey.hadsex
    fill_in "Intent graduate", with: @entry_survey.intent_graduate
    fill_in "Intent more study", with: @entry_survey.intent_more_study
    fill_in "Intent plans", with: @entry_survey.intent_plans
    fill_in "Intent speakup others", with: @entry_survey.intent_speakup_others
    fill_in "Intent speakup self", with: @entry_survey.intent_speakup_self
    fill_in "Intent study", with: @entry_survey.intent_study
    fill_in "Intent work", with: @entry_survey.intent_work
    check "Is hispanic" if @entry_survey.is_hispanic
    check "Is male" if @entry_survey.is_male
    check "Lang en" if @entry_survey.lang_en
    check "Lang other" if @entry_survey.lang_other
    fill_in "Lang other txt", with: @entry_survey.lang_other_txt
    check "Lang sp" if @entry_survey.lang_sp
    check "Lives couch" if @entry_survey.lives_couch
    check "Lives family" if @entry_survey.lives_family
    check "Lives foster family" if @entry_survey.lives_foster_family
    check "Lives foster group" if @entry_survey.lives_foster_group
    check "Lives hotel" if @entry_survey.lives_hotel
    check "Lives jail" if @entry_survey.lives_jail
    check "Lives none" if @entry_survey.lives_none
    check "Lives outside" if @entry_survey.lives_outside
    check "Lives shelter" if @entry_survey.lives_shelter
    fill_in "M age", with: @entry_survey.m_age
    fill_in "M grade", with: @entry_survey.m_grade
    fill_in "Magic", with: @entry_survey.magic
    fill_in "Num partners", with: @entry_survey.num_partners
    fill_in "Preg", with: @entry_survey.preg
    check "Race asian" if @entry_survey.race_asian
    check "Race black" if @entry_survey.race_black
    check "Race indian" if @entry_survey.race_indian
    check "Race other" if @entry_survey.race_other
    fill_in "Race other txt", with: @entry_survey.race_other_txt
    check "Race pacific" if @entry_survey.race_pacific
    check "Race white" if @entry_survey.race_white
    fill_in "Relate healthy", with: @entry_survey.relate_healthy
    fill_in "Relate info", with: @entry_survey.relate_info
    fill_in "Relate resist", with: @entry_survey.relate_resist
    fill_in "Relate talk", with: @entry_survey.relate_talk
    fill_in "Sexintent delaychild work", with: @entry_survey.sexintent_delaychild_work
    fill_in "Sexintent delaykid marry", with: @entry_survey.sexintent_delaykid_marry
    fill_in "Sexintent delaymarry work", with: @entry_survey.sexintent_delaymarry_work
    fill_in "Sexintent delaysex college", with: @entry_survey.sexintent_delaysex_college
    fill_in "Sexintent delaysex hs", with: @entry_survey.sexintent_delaysex_hs
    fill_in "Sexintent delaysex marry", with: @entry_survey.sexintent_delaysex_marry
    fill_in "Sti", with: @entry_survey.sti
    fill_in "Talk other", with: @entry_survey.talk_other
    fill_in "Talk parent", with: @entry_survey.talk_parent
    click_on "Update Entry survey"

    assert_text "Entry survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Entry survey" do
    visit entry_surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entry survey was successfully destroyed"
  end
end
