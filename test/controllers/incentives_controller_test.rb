require "test_helper"

class IncentivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incentive = incentives(:one)
  end

  test "should get index" do
    get incentives_url
    assert_response :success
  end

  test "should get new" do
    get new_incentive_url
    assert_response :success
  end

  test "should create incentive" do
    assert_difference('Incentive.count') do
      post incentives_url, params: { incentive: { fingerprint: @incentive.fingerprint, period: @incentive.period } }
    end

    assert_redirected_to incentive_url(Incentive.last)
  end

  test "should show incentive" do
    get incentive_url(@incentive)
    assert_response :success
  end

  test "should get edit" do
    get edit_incentive_url(@incentive)
    assert_response :success
  end

  test "should update incentive" do
    patch incentive_url(@incentive), params: { incentive: { fingerprint: @incentive.fingerprint, period: @incentive.period } }
    assert_redirected_to incentive_url(@incentive)
  end

  test "should destroy incentive" do
    assert_difference('Incentive.count', -1) do
      delete incentive_url(@incentive)
    end

    assert_redirected_to incentives_url
  end
end
