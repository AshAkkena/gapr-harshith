require "test_helper"

class SessionLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session_log = session_logs(:one)
  end

  test "should get index" do
    get session_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_session_log_url
    assert_response :success
  end

  test "should create session_log" do
    assert_difference('SessionLog.count') do
      post session_logs_url, params: { session_log: { adapted_anything: @session_log.adapted_anything, cohort_id: @session_log.cohort_id, enough_time: @session_log.enough_time, facilitator_initial: @session_log.facilitator_initial, happened_on: @session_log.happened_on, highschool_headcount: @session_log.highschool_headcount, impl_setting: @session_log.impl_setting, interest_proportion: @session_log.interest_proportion, magic_code: @session_log.magic_code, middleschool_headcount: @session_log.middleschool_headcount, minutes_taught: @session_log.minutes_taught, newface_hs_headcount: @session_log.newface_hs_headcount, newface_ms_headcount: @session_log.newface_ms_headcount, participant_referal: @session_log.participant_referal, participantion_proportion: @session_log.participantion_proportion, period: @session_log.period, taught_everything: @session_log.taught_everything } }
    end

    assert_redirected_to session_log_url(SessionLog.last)
  end

  test "should show session_log" do
    get session_log_url(@session_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_session_log_url(@session_log)
    assert_response :success
  end

  test "should update session_log" do
    patch session_log_url(@session_log), params: { session_log: { adapted_anything: @session_log.adapted_anything, cohort_id: @session_log.cohort_id, enough_time: @session_log.enough_time, facilitator_initial: @session_log.facilitator_initial, happened_on: @session_log.happened_on, highschool_headcount: @session_log.highschool_headcount, impl_setting: @session_log.impl_setting, interest_proportion: @session_log.interest_proportion, magic_code: @session_log.magic_code, middleschool_headcount: @session_log.middleschool_headcount, minutes_taught: @session_log.minutes_taught, newface_hs_headcount: @session_log.newface_hs_headcount, newface_ms_headcount: @session_log.newface_ms_headcount, participant_referal: @session_log.participant_referal, participantion_proportion: @session_log.participantion_proportion, period: @session_log.period, taught_everything: @session_log.taught_everything } }
    assert_redirected_to session_log_url(@session_log)
  end

  test "should destroy session_log" do
    assert_difference('SessionLog.count', -1) do
      delete session_log_url(@session_log)
    end

    assert_redirected_to session_logs_url
  end
end
