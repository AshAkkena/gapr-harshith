require "test_helper"

class CohoUpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coho_up = coho_ups(:one)
  end

  test "should get index" do
    get coho_ups_url
    assert_response :success
  end

  test "should get new" do
    get new_coho_up_url
    assert_response :success
  end

  test "should create coho_up" do
    assert_difference('CohoUp.count') do
      post coho_ups_url, params: { coho_up: { cohort_id: @coho_up.cohort_id, magic_code: @coho_up.magic_code } }
    end

    assert_redirected_to coho_up_url(CohoUp.last)
  end

  test "should show coho_up" do
    get coho_up_url(@coho_up)
    assert_response :success
  end

  test "should get edit" do
    get edit_coho_up_url(@coho_up)
    assert_response :success
  end

  test "should update coho_up" do
    patch coho_up_url(@coho_up), params: { coho_up: { cohort_id: @coho_up.cohort_id, magic_code: @coho_up.magic_code } }
    assert_redirected_to coho_up_url(@coho_up)
  end

  test "should destroy coho_up" do
    assert_difference('CohoUp.count', -1) do
      delete coho_up_url(@coho_up)
    end

    assert_redirected_to coho_ups_url
  end
end
