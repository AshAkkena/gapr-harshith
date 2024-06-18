require "test_helper"

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = providers(:one)
  end

  test "should get index" do
    get providers_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_url
    assert_response :success
  end

  test "should create provider" do
    assert_difference('Provider.count') do
      post providers_url, params: { provider: { award_amount: @provider.award_amount, challenges_attendance: @provider.challenges_attendance, challenges_covering_content: @provider.challenges_covering_content, challenges_engagement: @provider.challenges_engagement, challenges_facilities: @provider.challenges_facilities, challenges_natural_disasters: @provider.challenges_natural_disasters, challenges_negative_peer_interactions: @provider.challenges_negative_peer_interactions, challenges_recruiting_staff: @provider.challenges_recruiting_staff, challenges_recruiting_youth: @provider.challenges_recruiting_youth, challenges_staff_understanding: @provider.challenges_staff_understanding, challenges_stakeholder_support: @provider.challenges_stakeholder_support, challenges_turnover: @provider.challenges_turnover, challenges_youth_behavioral: @provider.challenges_youth_behavioral, facilitators_covid_vacancies_ever: @provider.facilitators_covid_vacancies_ever, facilitators_covid_vacancies_filled: @provider.facilitators_covid_vacancies_filled, facilitators_observed_just_once: @provider.facilitators_observed_just_once, facilitators_observed_twice_more: @provider.facilitators_observed_twice_more, facilitators_total: @provider.facilitators_total, facilitators_trained_core_model: @provider.facilitators_trained_core_model, nonprep_funding: @provider.nonprep_funding, period: @provider.period, pmms_aggregate_name: @provider.pmms_aggregate_name, provider_new: @provider.provider_new, provider_served_youth: @provider.provider_served_youth, staffing_administering: @provider.staffing_administering, staffing_administrative_covid_vacancies_ever: @provider.staffing_administrative_covid_vacancies_ever, staffing_administrative_covid_vacancies_filled: @provider.staffing_administrative_covid_vacancies_filled, staffing_fte_administering: @provider.staffing_fte_administering, staffing_fte_administering_covid_vacancies_ever: @provider.staffing_fte_administering_covid_vacancies_ever, staffing_fte_administering_covid_vacancies_filled: @provider.staffing_fte_administering_covid_vacancies_filled, tta_addressing_behavior: @provider.tta_addressing_behavior, tta_attendance: @provider.tta_attendance, tta_engagement: @provider.tta_engagement, tta_evaluation: @provider.tta_evaluation, tta_minimize_negative_peer: @provider.tta_minimize_negative_peer, tta_obtaining_support: @provider.tta_obtaining_support, tta_other_rating: @provider.tta_other_rating, tta_other_text: @provider.tta_other_text, tta_parent_support: @provider.tta_parent_support, tta_recruiting_staff: @provider.tta_recruiting_staff, tta_recruiting_youth: @provider.tta_recruiting_youth, tta_retaining_staff: @provider.tta_retaining_staff, tta_training_facilitators: @provider.tta_training_facilitators } }
    end

    assert_redirected_to provider_url(Provider.last)
  end

  test "should show provider" do
    get provider_url(@provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_url(@provider)
    assert_response :success
  end

  test "should update provider" do
    patch provider_url(@provider), params: { provider: { award_amount: @provider.award_amount, challenges_attendance: @provider.challenges_attendance, challenges_covering_content: @provider.challenges_covering_content, challenges_engagement: @provider.challenges_engagement, challenges_facilities: @provider.challenges_facilities, challenges_natural_disasters: @provider.challenges_natural_disasters, challenges_negative_peer_interactions: @provider.challenges_negative_peer_interactions, challenges_recruiting_staff: @provider.challenges_recruiting_staff, challenges_recruiting_youth: @provider.challenges_recruiting_youth, challenges_staff_understanding: @provider.challenges_staff_understanding, challenges_stakeholder_support: @provider.challenges_stakeholder_support, challenges_turnover: @provider.challenges_turnover, challenges_youth_behavioral: @provider.challenges_youth_behavioral, facilitators_covid_vacancies_ever: @provider.facilitators_covid_vacancies_ever, facilitators_covid_vacancies_filled: @provider.facilitators_covid_vacancies_filled, facilitators_observed_just_once: @provider.facilitators_observed_just_once, facilitators_observed_twice_more: @provider.facilitators_observed_twice_more, facilitators_total: @provider.facilitators_total, facilitators_trained_core_model: @provider.facilitators_trained_core_model, nonprep_funding: @provider.nonprep_funding, period: @provider.period, pmms_aggregate_name: @provider.pmms_aggregate_name, provider_new: @provider.provider_new, provider_served_youth: @provider.provider_served_youth, staffing_administering: @provider.staffing_administering, staffing_administrative_covid_vacancies_ever: @provider.staffing_administrative_covid_vacancies_ever, staffing_administrative_covid_vacancies_filled: @provider.staffing_administrative_covid_vacancies_filled, staffing_fte_administering: @provider.staffing_fte_administering, staffing_fte_administering_covid_vacancies_ever: @provider.staffing_fte_administering_covid_vacancies_ever, staffing_fte_administering_covid_vacancies_filled: @provider.staffing_fte_administering_covid_vacancies_filled, tta_addressing_behavior: @provider.tta_addressing_behavior, tta_attendance: @provider.tta_attendance, tta_engagement: @provider.tta_engagement, tta_evaluation: @provider.tta_evaluation, tta_minimize_negative_peer: @provider.tta_minimize_negative_peer, tta_obtaining_support: @provider.tta_obtaining_support, tta_other_rating: @provider.tta_other_rating, tta_other_text: @provider.tta_other_text, tta_parent_support: @provider.tta_parent_support, tta_recruiting_staff: @provider.tta_recruiting_staff, tta_recruiting_youth: @provider.tta_recruiting_youth, tta_retaining_staff: @provider.tta_retaining_staff, tta_training_facilitators: @provider.tta_training_facilitators } }
    assert_redirected_to provider_url(@provider)
  end

  test "should destroy provider" do
    assert_difference('Provider.count', -1) do
      delete provider_url(@provider)
    end

    assert_redirected_to providers_url
  end
end
