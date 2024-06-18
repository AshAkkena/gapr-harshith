require "test_helper"

class CohoDownAttendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coho_down_attend = coho_down_attends(:one)
  end

  test "should get index" do
    get coho_down_attends_url
    assert_response :success
  end

  test "should get new" do
    get new_coho_down_attend_url
    assert_response :success
  end

  test "should create coho_down_attend" do
    assert_difference('CohoDownAttend.count') do
      post coho_down_attends_url, params: { coho_down_attend: { cohort_id: @coho_down_attend.cohort_id, happened_on: @coho_down_attend.happened_on, highschool_headcount: @coho_down_attend.highschool_headcount, middleschool_headcount: @coho_down_attend.middleschool_headcount, newface_hs_headcount: @coho_down_attend.newface_hs_headcount, newface_ms_headcount: @coho_down_attend.newface_ms_headcount } }
    end

    assert_redirected_to coho_down_attend_url(CohoDownAttend.last)
  end

  test "should show coho_down_attend" do
    get coho_down_attend_url(@coho_down_attend)
    assert_response :success
  end

  test "should get edit" do
    get edit_coho_down_attend_url(@coho_down_attend)
    assert_response :success
  end

  test "should update coho_down_attend" do
    patch coho_down_attend_url(@coho_down_attend), params: { coho_down_attend: { cohort_id: @coho_down_attend.cohort_id, happened_on: @coho_down_attend.happened_on, highschool_headcount: @coho_down_attend.highschool_headcount, middleschool_headcount: @coho_down_attend.middleschool_headcount, newface_hs_headcount: @coho_down_attend.newface_hs_headcount, newface_ms_headcount: @coho_down_attend.newface_ms_headcount } }
    assert_redirected_to coho_down_attend_url(@coho_down_attend)
  end

  test "should destroy coho_down_attend" do
    assert_difference('CohoDownAttend.count', -1) do
      delete coho_down_attend_url(@coho_down_attend)
    end

    assert_redirected_to coho_down_attends_url
  end
end
