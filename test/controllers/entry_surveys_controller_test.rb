require "test_helper"

class EntrySurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entry_survey = entry_surveys(:one)
  end

  test "should get index" do
    get entry_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_entry_survey_url
    assert_response :success
  end

  test "should create entry_survey" do
    assert_difference('EntrySurvey.count') do
      post entry_surveys_url, params: { entry_survey: { behavior_emotion: @entry_survey.behavior_emotion, behavior_peer: @entry_survey.behavior_peer, behavior_think: @entry_survey.behavior_think, bevhaior_alcohol: @entry_survey.bevhaior_alcohol, cohort: @entry_survey.cohort, condom: @entry_survey.condom, contraceptive: @entry_survey.contraceptive, contractor: @entry_survey.contractor, curriculum: @entry_survey.curriculum, finance_bank: @entry_survey.finance_bank, finance_budget: @entry_survey.finance_budget, finance_cost: @entry_survey.finance_cost, finance_save: @entry_survey.finance_save, finance_track: @entry_survey.finance_track, h_age: @entry_survey.h_age, h_grade: @entry_survey.h_grade, hadsex: @entry_survey.hadsex, intent_graduate: @entry_survey.intent_graduate, intent_more_study: @entry_survey.intent_more_study, intent_plans: @entry_survey.intent_plans, intent_speakup_others: @entry_survey.intent_speakup_others, intent_speakup_self: @entry_survey.intent_speakup_self, intent_study: @entry_survey.intent_study, intent_work: @entry_survey.intent_work, is_hispanic: @entry_survey.is_hispanic, is_male: @entry_survey.is_male, lang_en: @entry_survey.lang_en, lang_other: @entry_survey.lang_other, lang_other_txt: @entry_survey.lang_other_txt, lang_sp: @entry_survey.lang_sp, lives_couch: @entry_survey.lives_couch, lives_family: @entry_survey.lives_family, lives_foster_family: @entry_survey.lives_foster_family, lives_foster_group: @entry_survey.lives_foster_group, lives_hotel: @entry_survey.lives_hotel, lives_jail: @entry_survey.lives_jail, lives_none: @entry_survey.lives_none, lives_outside: @entry_survey.lives_outside, lives_shelter: @entry_survey.lives_shelter, m_age: @entry_survey.m_age, m_grade: @entry_survey.m_grade, magic: @entry_survey.magic, num_partners: @entry_survey.num_partners, preg: @entry_survey.preg, race_asian: @entry_survey.race_asian, race_black: @entry_survey.race_black, race_indian: @entry_survey.race_indian, race_other: @entry_survey.race_other, race_other_txt: @entry_survey.race_other_txt, race_pacific: @entry_survey.race_pacific, race_white: @entry_survey.race_white, relate_healthy: @entry_survey.relate_healthy, relate_info: @entry_survey.relate_info, relate_resist: @entry_survey.relate_resist, relate_talk: @entry_survey.relate_talk, sexintent_delaychild_work: @entry_survey.sexintent_delaychild_work, sexintent_delaykid_marry: @entry_survey.sexintent_delaykid_marry, sexintent_delaymarry_work: @entry_survey.sexintent_delaymarry_work, sexintent_delaysex_college: @entry_survey.sexintent_delaysex_college, sexintent_delaysex_hs: @entry_survey.sexintent_delaysex_hs, sexintent_delaysex_marry: @entry_survey.sexintent_delaysex_marry, sti: @entry_survey.sti, talk_other: @entry_survey.talk_other, talk_parent: @entry_survey.talk_parent } }
    end

    assert_redirected_to entry_survey_url(EntrySurvey.last)
  end

  test "should show entry_survey" do
    get entry_survey_url(@entry_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_entry_survey_url(@entry_survey)
    assert_response :success
  end

  test "should update entry_survey" do
    patch entry_survey_url(@entry_survey), params: { entry_survey: { behavior_emotion: @entry_survey.behavior_emotion, behavior_peer: @entry_survey.behavior_peer, behavior_think: @entry_survey.behavior_think, bevhaior_alcohol: @entry_survey.bevhaior_alcohol, cohort: @entry_survey.cohort, condom: @entry_survey.condom, contraceptive: @entry_survey.contraceptive, contractor: @entry_survey.contractor, curriculum: @entry_survey.curriculum, finance_bank: @entry_survey.finance_bank, finance_budget: @entry_survey.finance_budget, finance_cost: @entry_survey.finance_cost, finance_save: @entry_survey.finance_save, finance_track: @entry_survey.finance_track, h_age: @entry_survey.h_age, h_grade: @entry_survey.h_grade, hadsex: @entry_survey.hadsex, intent_graduate: @entry_survey.intent_graduate, intent_more_study: @entry_survey.intent_more_study, intent_plans: @entry_survey.intent_plans, intent_speakup_others: @entry_survey.intent_speakup_others, intent_speakup_self: @entry_survey.intent_speakup_self, intent_study: @entry_survey.intent_study, intent_work: @entry_survey.intent_work, is_hispanic: @entry_survey.is_hispanic, is_male: @entry_survey.is_male, lang_en: @entry_survey.lang_en, lang_other: @entry_survey.lang_other, lang_other_txt: @entry_survey.lang_other_txt, lang_sp: @entry_survey.lang_sp, lives_couch: @entry_survey.lives_couch, lives_family: @entry_survey.lives_family, lives_foster_family: @entry_survey.lives_foster_family, lives_foster_group: @entry_survey.lives_foster_group, lives_hotel: @entry_survey.lives_hotel, lives_jail: @entry_survey.lives_jail, lives_none: @entry_survey.lives_none, lives_outside: @entry_survey.lives_outside, lives_shelter: @entry_survey.lives_shelter, m_age: @entry_survey.m_age, m_grade: @entry_survey.m_grade, magic: @entry_survey.magic, num_partners: @entry_survey.num_partners, preg: @entry_survey.preg, race_asian: @entry_survey.race_asian, race_black: @entry_survey.race_black, race_indian: @entry_survey.race_indian, race_other: @entry_survey.race_other, race_other_txt: @entry_survey.race_other_txt, race_pacific: @entry_survey.race_pacific, race_white: @entry_survey.race_white, relate_healthy: @entry_survey.relate_healthy, relate_info: @entry_survey.relate_info, relate_resist: @entry_survey.relate_resist, relate_talk: @entry_survey.relate_talk, sexintent_delaychild_work: @entry_survey.sexintent_delaychild_work, sexintent_delaykid_marry: @entry_survey.sexintent_delaykid_marry, sexintent_delaymarry_work: @entry_survey.sexintent_delaymarry_work, sexintent_delaysex_college: @entry_survey.sexintent_delaysex_college, sexintent_delaysex_hs: @entry_survey.sexintent_delaysex_hs, sexintent_delaysex_marry: @entry_survey.sexintent_delaysex_marry, sti: @entry_survey.sti, talk_other: @entry_survey.talk_other, talk_parent: @entry_survey.talk_parent } }
    assert_redirected_to entry_survey_url(@entry_survey)
  end

  test "should destroy entry_survey" do
    assert_difference('EntrySurvey.count', -1) do
      delete entry_survey_url(@entry_survey)
    end

    assert_redirected_to entry_surveys_url
  end
end
