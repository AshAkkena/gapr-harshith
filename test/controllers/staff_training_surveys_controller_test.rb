require "test_helper"

class StaffTrainingSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff_training_survey = staff_training_surveys(:one)
  end

  test "should get index" do
    get staff_training_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_staff_training_survey_url
    assert_response :success
  end

  test "should create staff_training_survey" do
    assert_difference('StaffTrainingSurvey.count') do
      post staff_training_surveys_url, params: { staff_training_survey: { affiliation: @staff_training_survey.affiliation, details_good: @staff_training_survey.details_good, details_improvement: @staff_training_survey.details_improvement, quality_interest: @staff_training_survey.quality_interest, quality_relevance: @staff_training_survey.quality_relevance, quality_will_recommend: @staff_training_survey.quality_will_recommend, quality_will_share: @staff_training_survey.quality_will_share, quality_will_use: @staff_training_survey.quality_will_use } }
    end

    assert_redirected_to staff_training_survey_url(StaffTrainingSurvey.last)
  end

  test "should show staff_training_survey" do
    get staff_training_survey_url(@staff_training_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_staff_training_survey_url(@staff_training_survey)
    assert_response :success
  end

  test "should update staff_training_survey" do
    patch staff_training_survey_url(@staff_training_survey), params: { staff_training_survey: { affiliation: @staff_training_survey.affiliation, details_good: @staff_training_survey.details_good, details_improvement: @staff_training_survey.details_improvement, quality_interest: @staff_training_survey.quality_interest, quality_relevance: @staff_training_survey.quality_relevance, quality_will_recommend: @staff_training_survey.quality_will_recommend, quality_will_share: @staff_training_survey.quality_will_share, quality_will_use: @staff_training_survey.quality_will_use } }
    assert_redirected_to staff_training_survey_url(@staff_training_survey)
  end

  test "should destroy staff_training_survey" do
    assert_difference('StaffTrainingSurvey.count', -1) do
      delete staff_training_survey_url(@staff_training_survey)
    end

    assert_redirected_to staff_training_surveys_url
  end
end
