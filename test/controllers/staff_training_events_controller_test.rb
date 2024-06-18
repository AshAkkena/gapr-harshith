require "test_helper"

class StaffTrainingEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff_training_event = staff_training_events(:one)
  end

  test "should get index" do
    get staff_training_events_url
    assert_response :success
  end

  test "should get new" do
    get new_staff_training_event_url
    assert_response :success
  end

  test "should create staff_training_event" do
    assert_difference('StaffTrainingEvent.count') do
      post staff_training_events_url, params: { staff_training_event: { period: @staff_training_event.period, training_date: @staff_training_event.training_date, training_name: @staff_training_event.training_name, training_place: @staff_training_event.training_place, training_trainer: @staff_training_event.training_trainer } }
    end

    assert_redirected_to staff_training_event_url(StaffTrainingEvent.last)
  end

  test "should show staff_training_event" do
    get staff_training_event_url(@staff_training_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_staff_training_event_url(@staff_training_event)
    assert_response :success
  end

  test "should update staff_training_event" do
    patch staff_training_event_url(@staff_training_event), params: { staff_training_event: { period: @staff_training_event.period, training_date: @staff_training_event.training_date, training_name: @staff_training_event.training_name, training_place: @staff_training_event.training_place, training_trainer: @staff_training_event.training_trainer } }
    assert_redirected_to staff_training_event_url(@staff_training_event)
  end

  test "should destroy staff_training_event" do
    assert_difference('StaffTrainingEvent.count', -1) do
      delete staff_training_event_url(@staff_training_event)
    end

    assert_redirected_to staff_training_events_url
  end
end
