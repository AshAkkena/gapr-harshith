require "test_helper"

class HandoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @handout = handouts(:one)
  end

  test "should get index" do
    get handouts_url
    assert_response :success
  end

  test "should get new" do
    get new_handout_url
    assert_response :success
  end

  test "should create handout" do
    assert_difference('Handout.count') do
      post handouts_url, params: { handout: { description: @handout.description, title: @handout.title } }
    end

    assert_redirected_to handout_url(Handout.last)
  end

  test "should show handout" do
    get handout_url(@handout)
    assert_response :success
  end

  test "should get edit" do
    get edit_handout_url(@handout)
    assert_response :success
  end

  test "should update handout" do
    patch handout_url(@handout), params: { handout: { description: @handout.description, title: @handout.title } }
    assert_redirected_to handout_url(@handout)
  end

  test "should destroy handout" do
    assert_difference('Handout.count', -1) do
      delete handout_url(@handout)
    end

    assert_redirected_to handouts_url
  end
end
