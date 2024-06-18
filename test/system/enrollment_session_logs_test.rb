require "application_system_test_case"

class EnrollmentSessionLogsTest < ApplicationSystemTestCase
  setup do
    @enrollment_session_log = enrollment_session_logs(:one)
  end

  test "visiting the index" do
    visit enrollment_session_logs_url
    assert_selector "h1", text: "Enrollment Session Logs"
  end

  test "creating a Enrollment session log" do
    visit enrollment_session_logs_url
    click_on "New Enrollment Session Log"

    fill_in "Enrollment", with: @enrollment_session_log.enrollment_id
    fill_in "Session log", with: @enrollment_session_log.session_log_id
    click_on "Create Enrollment session log"

    assert_text "Enrollment session log was successfully created"
    click_on "Back"
  end

  test "updating a Enrollment session log" do
    visit enrollment_session_logs_url
    click_on "Edit", match: :first

    fill_in "Enrollment", with: @enrollment_session_log.enrollment_id
    fill_in "Session log", with: @enrollment_session_log.session_log_id
    click_on "Update Enrollment session log"

    assert_text "Enrollment session log was successfully updated"
    click_on "Back"
  end

  test "destroying a Enrollment session log" do
    visit enrollment_session_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Enrollment session log was successfully destroyed"
  end
end
