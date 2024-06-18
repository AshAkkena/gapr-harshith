require "test_helper"

class CohoDownsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coho_down = coho_downs(:one)
  end

  test "should get index" do
    get coho_downs_url
    assert_response :success
  end

  test "should get new" do
    get new_coho_down_url
    assert_response :success
  end

  test "should create coho_down" do
    assert_difference('CohoDown.count') do
      post coho_downs_url, params: { coho_down: { census_adjudication: @coho_down.census_adjudication, census_foster: @coho_down.census_foster, census_homeless: @coho_down.census_homeless, census_pregnant_parenting: @coho_down.census_pregnant_parenting, cohort_id: @coho_down.cohort_id, covid_virtualization: @coho_down.covid_virtualization, main_setting: @coho_down.main_setting, program_complete: @coho_down.program_complete, total_graduated_hs: @coho_down.total_graduated_hs, total_graduated_ms: @coho_down.total_graduated_ms, total_hours_delivered: @coho_down.total_hours_delivered, total_initiated_hs: @coho_down.total_initiated_hs, total_initiated_ms: @coho_down.total_initiated_ms } }
    end

    assert_redirected_to coho_down_url(CohoDown.last)
  end

  test "should show coho_down" do
    get coho_down_url(@coho_down)
    assert_response :success
  end

  test "should get edit" do
    get edit_coho_down_url(@coho_down)
    assert_response :success
  end

  test "should update coho_down" do
    patch coho_down_url(@coho_down), params: { coho_down: { census_adjudication: @coho_down.census_adjudication, census_foster: @coho_down.census_foster, census_homeless: @coho_down.census_homeless, census_pregnant_parenting: @coho_down.census_pregnant_parenting, cohort_id: @coho_down.cohort_id, covid_virtualization: @coho_down.covid_virtualization, main_setting: @coho_down.main_setting, program_complete: @coho_down.program_complete, total_graduated_hs: @coho_down.total_graduated_hs, total_graduated_ms: @coho_down.total_graduated_ms, total_hours_delivered: @coho_down.total_hours_delivered, total_initiated_hs: @coho_down.total_initiated_hs, total_initiated_ms: @coho_down.total_initiated_ms } }
    assert_redirected_to coho_down_url(@coho_down)
  end

  test "should destroy coho_down" do
    assert_difference('CohoDown.count', -1) do
      delete coho_down_url(@coho_down)
    end

    assert_redirected_to coho_downs_url
  end
end
