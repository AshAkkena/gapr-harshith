require "test_helper"

class ExitSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exit_survey = exit_surveys(:one)
  end

  test "should get index" do
    get exit_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_exit_survey_url
    assert_response :success
  end

  test "should create exit_survey" do
    assert_difference('ExitSurvey.count') do
      post exit_surveys_url, params: { exit_survey: { abstain_notyes_condom: @exit_survey.abstain_notyes_condom, abstain_notyes_contra: @exit_survey.abstain_notyes_contra, abstain_notyes_havesex: @exit_survey.abstain_notyes_havesex, abstain_yes_consequences: @exit_survey.abstain_yes_consequences, abstain_yes_plans: @exit_survey.abstain_yes_plans, abstain_yes_preg: @exit_survey.abstain_yes_preg, abstain_yes_sti: @exit_survey.abstain_yes_sti, cohort: @exit_survey.cohort, contractor: @exit_survey.contractor, curriculum: @exit_survey.curriculum, domestic: @exit_survey.domestic, h_age: @exit_survey.h_age, h_grade: @exit_survey.h_grade, impact_behavior_alcohol: @exit_survey.impact_behavior_alcohol, impact_behavior_emotion: @exit_survey.impact_behavior_emotion, impact_behavior_peer: @exit_survey.impact_behavior_peer, impact_behavior_think: @exit_survey.impact_behavior_think, impact_finance_bank: @exit_survey.impact_finance_bank, impact_finance_budget: @exit_survey.impact_finance_budget, impact_finance_cost: @exit_survey.impact_finance_cost, impact_finance_save: @exit_survey.impact_finance_save, impact_finance_track: @exit_survey.impact_finance_track, impact_intent_graduate: @exit_survey.impact_intent_graduate, impact_intent_more_study: @exit_survey.impact_intent_more_study, impact_intent_plans: @exit_survey.impact_intent_plans, impact_intent_study: @exit_survey.impact_intent_study, impact_intent_work: @exit_survey.impact_intent_work, impact_relate_healthy: @exit_survey.impact_relate_healthy, impact_relate_resist: @exit_survey.impact_relate_resist, impact_relate_talk: @exit_survey.impact_relate_talk, impact_talk_other: @exit_survey.impact_talk_other, impact_talk_parent: @exit_survey.impact_talk_parent, is_hispanic: @exit_survey.is_hispanic, is_male: @exit_survey.is_male, lang: @exit_survey.lang, lang_other_txt: @exit_survey.lang_other_txt, m_age: @exit_survey.m_age, m_grade: @exit_survey.m_grade, magic: @exit_survey.magic, percep_ask: @exit_survey.percep_ask, percep_clear: @exit_survey.percep_clear, percep_learn: @exit_survey.percep_learn, percep_respect: @exit_survey.percep_respect, plan_abstainsex: @exit_survey.plan_abstainsex, race: @exit_survey.race, race_other_txt: @exit_survey.race_other_txt, satisfaction_abstain: @exit_survey.satisfaction_abstain, satisfaction_contra: @exit_survey.satisfaction_contra } }
    end

    assert_redirected_to exit_survey_url(ExitSurvey.last)
  end

  test "should show exit_survey" do
    get exit_survey_url(@exit_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_exit_survey_url(@exit_survey)
    assert_response :success
  end

  test "should update exit_survey" do
    patch exit_survey_url(@exit_survey), params: { exit_survey: { abstain_notyes_condom: @exit_survey.abstain_notyes_condom, abstain_notyes_contra: @exit_survey.abstain_notyes_contra, abstain_notyes_havesex: @exit_survey.abstain_notyes_havesex, abstain_yes_consequences: @exit_survey.abstain_yes_consequences, abstain_yes_plans: @exit_survey.abstain_yes_plans, abstain_yes_preg: @exit_survey.abstain_yes_preg, abstain_yes_sti: @exit_survey.abstain_yes_sti, cohort: @exit_survey.cohort, contractor: @exit_survey.contractor, curriculum: @exit_survey.curriculum, domestic: @exit_survey.domestic, h_age: @exit_survey.h_age, h_grade: @exit_survey.h_grade, impact_behavior_alcohol: @exit_survey.impact_behavior_alcohol, impact_behavior_emotion: @exit_survey.impact_behavior_emotion, impact_behavior_peer: @exit_survey.impact_behavior_peer, impact_behavior_think: @exit_survey.impact_behavior_think, impact_finance_bank: @exit_survey.impact_finance_bank, impact_finance_budget: @exit_survey.impact_finance_budget, impact_finance_cost: @exit_survey.impact_finance_cost, impact_finance_save: @exit_survey.impact_finance_save, impact_finance_track: @exit_survey.impact_finance_track, impact_intent_graduate: @exit_survey.impact_intent_graduate, impact_intent_more_study: @exit_survey.impact_intent_more_study, impact_intent_plans: @exit_survey.impact_intent_plans, impact_intent_study: @exit_survey.impact_intent_study, impact_intent_work: @exit_survey.impact_intent_work, impact_relate_healthy: @exit_survey.impact_relate_healthy, impact_relate_resist: @exit_survey.impact_relate_resist, impact_relate_talk: @exit_survey.impact_relate_talk, impact_talk_other: @exit_survey.impact_talk_other, impact_talk_parent: @exit_survey.impact_talk_parent, is_hispanic: @exit_survey.is_hispanic, is_male: @exit_survey.is_male, lang: @exit_survey.lang, lang_other_txt: @exit_survey.lang_other_txt, m_age: @exit_survey.m_age, m_grade: @exit_survey.m_grade, magic: @exit_survey.magic, percep_ask: @exit_survey.percep_ask, percep_clear: @exit_survey.percep_clear, percep_learn: @exit_survey.percep_learn, percep_respect: @exit_survey.percep_respect, plan_abstainsex: @exit_survey.plan_abstainsex, race: @exit_survey.race, race_other_txt: @exit_survey.race_other_txt, satisfaction_abstain: @exit_survey.satisfaction_abstain, satisfaction_contra: @exit_survey.satisfaction_contra } }
    assert_redirected_to exit_survey_url(@exit_survey)
  end

  test "should destroy exit_survey" do
    assert_difference('ExitSurvey.count', -1) do
      delete exit_survey_url(@exit_survey)
    end

    assert_redirected_to exit_surveys_url
  end
end
