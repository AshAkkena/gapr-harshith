require "application_system_test_case"

class StaffTrainingSurveysTest < ApplicationSystemTestCase
  setup do
    @staff_training_survey = staff_training_surveys(:one)
  end

  test "visiting the index" do
    visit staff_training_surveys_url
    assert_selector "h1", text: "Staff Training Surveys"
  end

  test "creating a Staff training survey" do
    visit staff_training_surveys_url
    click_on "New Staff Training Survey"

    fill_in "Affiliation", with: @staff_training_survey.affiliation
    fill_in "Details good", with: @staff_training_survey.details_good
    fill_in "Details improvement", with: @staff_training_survey.details_improvement
    fill_in "Quality interest", with: @staff_training_survey.quality_interest
    fill_in "Quality relevance", with: @staff_training_survey.quality_relevance
    fill_in "Quality will recommend", with: @staff_training_survey.quality_will_recommend
    fill_in "Quality will share", with: @staff_training_survey.quality_will_share
    fill_in "Quality will use", with: @staff_training_survey.quality_will_use
    click_on "Create Staff training survey"

    assert_text "Staff training survey was successfully created"
    click_on "Back"
  end

  test "updating a Staff training survey" do
    visit staff_training_surveys_url
    click_on "Edit", match: :first

    fill_in "Affiliation", with: @staff_training_survey.affiliation
    fill_in "Details good", with: @staff_training_survey.details_good
    fill_in "Details improvement", with: @staff_training_survey.details_improvement
    fill_in "Quality interest", with: @staff_training_survey.quality_interest
    fill_in "Quality relevance", with: @staff_training_survey.quality_relevance
    fill_in "Quality will recommend", with: @staff_training_survey.quality_will_recommend
    fill_in "Quality will share", with: @staff_training_survey.quality_will_share
    fill_in "Quality will use", with: @staff_training_survey.quality_will_use
    click_on "Update Staff training survey"

    assert_text "Staff training survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Staff training survey" do
    visit staff_training_surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Staff training survey was successfully destroyed"
  end
end
