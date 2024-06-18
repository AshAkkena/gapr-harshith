require "application_system_test_case"

class StaffTrainingEventsTest < ApplicationSystemTestCase
  setup do
    @staff_training_event = staff_training_events(:one)
  end

  test "visiting the index" do
    visit staff_training_events_url
    assert_selector "h1", text: "Staff Training Events"
  end

  test "creating a Staff training event" do
    visit staff_training_events_url
    click_on "New Staff Training Event"

    fill_in "Period", with: @staff_training_event.period
    fill_in "Training date", with: @staff_training_event.training_date
    fill_in "Training name", with: @staff_training_event.training_name
    fill_in "Training place", with: @staff_training_event.training_place
    fill_in "Training trainer", with: @staff_training_event.training_trainer
    click_on "Create Staff training event"

    assert_text "Staff training event was successfully created"
    click_on "Back"
  end

  test "updating a Staff training event" do
    visit staff_training_events_url
    click_on "Edit", match: :first

    fill_in "Period", with: @staff_training_event.period
    fill_in "Training date", with: @staff_training_event.training_date
    fill_in "Training name", with: @staff_training_event.training_name
    fill_in "Training place", with: @staff_training_event.training_place
    fill_in "Training trainer", with: @staff_training_event.training_trainer
    click_on "Update Staff training event"

    assert_text "Staff training event was successfully updated"
    click_on "Back"
  end

  test "destroying a Staff training event" do
    visit staff_training_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Staff training event was successfully destroyed"
  end
end
