require "application_system_test_case"

class SessionLogsTest < ApplicationSystemTestCase
  setup do
    @session_log = session_logs(:one)
  end

  test "visiting the index" do
    visit session_logs_url
    assert_selector "h1", text: "Session Logs"
  end

  test "creating a Session log" do
    visit session_logs_url
    click_on "New Session Log"

    check "Adapted anything" if @session_log.adapted_anything
    fill_in "Cohort", with: @session_log.cohort_id
    fill_in "Enough time", with: @session_log.enough_time
    fill_in "Facilitator initial", with: @session_log.facilitator_initial
    fill_in "Happened on", with: @session_log.happened_on
    fill_in "Highschool headcount", with: @session_log.highschool_headcount
    fill_in "Impl setting", with: @session_log.impl_setting
    fill_in "Interest proportion", with: @session_log.interest_proportion
    fill_in "Magic code", with: @session_log.magic_code
    fill_in "Middleschool headcount", with: @session_log.middleschool_headcount
    fill_in "Minutes taught", with: @session_log.minutes_taught
    fill_in "Newface hs headcount", with: @session_log.newface_hs_headcount
    fill_in "Newface ms headcount", with: @session_log.newface_ms_headcount
    check "Participant referal" if @session_log.participant_referal
    fill_in "Participantion proportion", with: @session_log.participantion_proportion
    fill_in "Period", with: @session_log.period
    check "Taught everything" if @session_log.taught_everything
    click_on "Create Session log"

    assert_text "Session log was successfully created"
    click_on "Back"
  end

  test "updating a Session log" do
    visit session_logs_url
    click_on "Edit", match: :first

    check "Adapted anything" if @session_log.adapted_anything
    fill_in "Cohort", with: @session_log.cohort_id
    fill_in "Enough time", with: @session_log.enough_time
    fill_in "Facilitator initial", with: @session_log.facilitator_initial
    fill_in "Happened on", with: @session_log.happened_on
    fill_in "Highschool headcount", with: @session_log.highschool_headcount
    fill_in "Impl setting", with: @session_log.impl_setting
    fill_in "Interest proportion", with: @session_log.interest_proportion
    fill_in "Magic code", with: @session_log.magic_code
    fill_in "Middleschool headcount", with: @session_log.middleschool_headcount
    fill_in "Minutes taught", with: @session_log.minutes_taught
    fill_in "Newface hs headcount", with: @session_log.newface_hs_headcount
    fill_in "Newface ms headcount", with: @session_log.newface_ms_headcount
    check "Participant referal" if @session_log.participant_referal
    fill_in "Participantion proportion", with: @session_log.participantion_proportion
    fill_in "Period", with: @session_log.period
    check "Taught everything" if @session_log.taught_everything
    click_on "Update Session log"

    assert_text "Session log was successfully updated"
    click_on "Back"
  end

  test "destroying a Session log" do
    visit session_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Session log was successfully destroyed"
  end
end
