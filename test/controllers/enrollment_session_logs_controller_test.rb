require "test_helper"

class EnrollmentSessionLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enrollment_session_log = enrollment_session_logs(:one)
  end

  test "should get index" do
    get enrollment_session_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_enrollment_session_log_url
    assert_response :success
  end

  test "should create enrollment_session_log" do
    assert_difference('EnrollmentSessionLog.count') do
      post enrollment_session_logs_url, params: { enrollment_session_log: { enrollment_id: @enrollment_session_log.enrollment_id, session_log_id: @enrollment_session_log.session_log_id } }
    end

    assert_redirected_to enrollment_session_log_url(EnrollmentSessionLog.last)
  end

  test "should show enrollment_session_log" do
    get enrollment_session_log_url(@enrollment_session_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_enrollment_session_log_url(@enrollment_session_log)
    assert_response :success
  end

  test "should update enrollment_session_log" do
    patch enrollment_session_log_url(@enrollment_session_log), params: { enrollment_session_log: { enrollment_id: @enrollment_session_log.enrollment_id, session_log_id: @enrollment_session_log.session_log_id } }
    assert_redirected_to enrollment_session_log_url(@enrollment_session_log)
  end

  test "should destroy enrollment_session_log" do
    assert_difference('EnrollmentSessionLog.count', -1) do
      delete enrollment_session_log_url(@enrollment_session_log)
    end

    assert_redirected_to enrollment_session_logs_url
  end
end
