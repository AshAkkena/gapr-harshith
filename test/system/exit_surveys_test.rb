require "application_system_test_case"

class ExitSurveysTest < ApplicationSystemTestCase
  setup do
    @exit_survey = exit_surveys(:one)
  end

  test "visiting the index" do
    visit exit_surveys_url
    assert_selector "h1", text: "Exit Surveys"
  end

  test "creating a Exit survey" do
    visit exit_surveys_url
    click_on "New Exit Survey"

    fill_in "Abstain notyes condom", with: @exit_survey.abstain_notyes_condom
    fill_in "Abstain notyes contra", with: @exit_survey.abstain_notyes_contra
    fill_in "Abstain notyes havesex", with: @exit_survey.abstain_notyes_havesex
    fill_in "Abstain yes consequences", with: @exit_survey.abstain_yes_consequences
    fill_in "Abstain yes plans", with: @exit_survey.abstain_yes_plans
    fill_in "Abstain yes preg", with: @exit_survey.abstain_yes_preg
    fill_in "Abstain yes sti", with: @exit_survey.abstain_yes_sti
    fill_in "Cohort", with: @exit_survey.cohort
    fill_in "Contractor", with: @exit_survey.contractor
    fill_in "Curriculum", with: @exit_survey.curriculum
    fill_in "Domestic", with: @exit_survey.domestic
    fill_in "H age", with: @exit_survey.h_age
    fill_in "H grade", with: @exit_survey.h_grade
    fill_in "Impact behavior alcohol", with: @exit_survey.impact_behavior_alcohol
    fill_in "Impact behavior emotion", with: @exit_survey.impact_behavior_emotion
    fill_in "Impact behavior peer", with: @exit_survey.impact_behavior_peer
    fill_in "Impact behavior think", with: @exit_survey.impact_behavior_think
    fill_in "Impact finance bank", with: @exit_survey.impact_finance_bank
    fill_in "Impact finance budget", with: @exit_survey.impact_finance_budget
    fill_in "Impact finance cost", with: @exit_survey.impact_finance_cost
    fill_in "Impact finance save", with: @exit_survey.impact_finance_save
    fill_in "Impact finance track", with: @exit_survey.impact_finance_track
    fill_in "Impact intent graduate", with: @exit_survey.impact_intent_graduate
    fill_in "Impact intent more study", with: @exit_survey.impact_intent_more_study
    fill_in "Impact intent plans", with: @exit_survey.impact_intent_plans
    fill_in "Impact intent study", with: @exit_survey.impact_intent_study
    fill_in "Impact intent work", with: @exit_survey.impact_intent_work
    fill_in "Impact relate healthy", with: @exit_survey.impact_relate_healthy
    fill_in "Impact relate resist", with: @exit_survey.impact_relate_resist
    fill_in "Impact relate talk", with: @exit_survey.impact_relate_talk
    fill_in "Impact talk other", with: @exit_survey.impact_talk_other
    fill_in "Impact talk parent", with: @exit_survey.impact_talk_parent
    fill_in "Is hispanic", with: @exit_survey.is_hispanic
    fill_in "Is male", with: @exit_survey.is_male
    fill_in "Lang", with: @exit_survey.lang
    fill_in "Lang other txt", with: @exit_survey.lang_other_txt
    fill_in "M age", with: @exit_survey.m_age
    fill_in "M grade", with: @exit_survey.m_grade
    fill_in "Magic", with: @exit_survey.magic
    fill_in "Percep ask", with: @exit_survey.percep_ask
    fill_in "Percep clear", with: @exit_survey.percep_clear
    fill_in "Percep learn", with: @exit_survey.percep_learn
    fill_in "Percep respect", with: @exit_survey.percep_respect
    fill_in "Plan abstainsex", with: @exit_survey.plan_abstainsex
    fill_in "Race", with: @exit_survey.race
    fill_in "Race other txt", with: @exit_survey.race_other_txt
    fill_in "Satisfaction abstain", with: @exit_survey.satisfaction_abstain
    fill_in "Satisfaction contra", with: @exit_survey.satisfaction_contra
    click_on "Create Exit survey"

    assert_text "Exit survey was successfully created"
    click_on "Back"
  end

  test "updating a Exit survey" do
    visit exit_surveys_url
    click_on "Edit", match: :first

    fill_in "Abstain notyes condom", with: @exit_survey.abstain_notyes_condom
    fill_in "Abstain notyes contra", with: @exit_survey.abstain_notyes_contra
    fill_in "Abstain notyes havesex", with: @exit_survey.abstain_notyes_havesex
    fill_in "Abstain yes consequences", with: @exit_survey.abstain_yes_consequences
    fill_in "Abstain yes plans", with: @exit_survey.abstain_yes_plans
    fill_in "Abstain yes preg", with: @exit_survey.abstain_yes_preg
    fill_in "Abstain yes sti", with: @exit_survey.abstain_yes_sti
    fill_in "Cohort", with: @exit_survey.cohort
    fill_in "Contractor", with: @exit_survey.contractor
    fill_in "Curriculum", with: @exit_survey.curriculum
    fill_in "Domestic", with: @exit_survey.domestic
    fill_in "H age", with: @exit_survey.h_age
    fill_in "H grade", with: @exit_survey.h_grade
    fill_in "Impact behavior alcohol", with: @exit_survey.impact_behavior_alcohol
    fill_in "Impact behavior emotion", with: @exit_survey.impact_behavior_emotion
    fill_in "Impact behavior peer", with: @exit_survey.impact_behavior_peer
    fill_in "Impact behavior think", with: @exit_survey.impact_behavior_think
    fill_in "Impact finance bank", with: @exit_survey.impact_finance_bank
    fill_in "Impact finance budget", with: @exit_survey.impact_finance_budget
    fill_in "Impact finance cost", with: @exit_survey.impact_finance_cost
    fill_in "Impact finance save", with: @exit_survey.impact_finance_save
    fill_in "Impact finance track", with: @exit_survey.impact_finance_track
    fill_in "Impact intent graduate", with: @exit_survey.impact_intent_graduate
    fill_in "Impact intent more study", with: @exit_survey.impact_intent_more_study
    fill_in "Impact intent plans", with: @exit_survey.impact_intent_plans
    fill_in "Impact intent study", with: @exit_survey.impact_intent_study
    fill_in "Impact intent work", with: @exit_survey.impact_intent_work
    fill_in "Impact relate healthy", with: @exit_survey.impact_relate_healthy
    fill_in "Impact relate resist", with: @exit_survey.impact_relate_resist
    fill_in "Impact relate talk", with: @exit_survey.impact_relate_talk
    fill_in "Impact talk other", with: @exit_survey.impact_talk_other
    fill_in "Impact talk parent", with: @exit_survey.impact_talk_parent
    fill_in "Is hispanic", with: @exit_survey.is_hispanic
    fill_in "Is male", with: @exit_survey.is_male
    fill_in "Lang", with: @exit_survey.lang
    fill_in "Lang other txt", with: @exit_survey.lang_other_txt
    fill_in "M age", with: @exit_survey.m_age
    fill_in "M grade", with: @exit_survey.m_grade
    fill_in "Magic", with: @exit_survey.magic
    fill_in "Percep ask", with: @exit_survey.percep_ask
    fill_in "Percep clear", with: @exit_survey.percep_clear
    fill_in "Percep learn", with: @exit_survey.percep_learn
    fill_in "Percep respect", with: @exit_survey.percep_respect
    fill_in "Plan abstainsex", with: @exit_survey.plan_abstainsex
    fill_in "Race", with: @exit_survey.race
    fill_in "Race other txt", with: @exit_survey.race_other_txt
    fill_in "Satisfaction abstain", with: @exit_survey.satisfaction_abstain
    fill_in "Satisfaction contra", with: @exit_survey.satisfaction_contra
    click_on "Update Exit survey"

    assert_text "Exit survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Exit survey" do
    visit exit_surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Exit survey was successfully destroyed"
  end
end
