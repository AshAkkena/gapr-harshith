require "test_helper"

class GranteesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grantee = grantees(:one)
  end

  test "should get index" do
    get grantees_url
    assert_response :success
  end

  test "should get new" do
    get new_grantee_url
    assert_response :success
  end

  test "should create grantee" do
    assert_difference('Grantee.count') do
      post grantees_url, params: { grantee: { allocation_administrative: @grantee.allocation_administrative, allocation_direct_service: @grantee.allocation_direct_service, allocation_evaluation: @grantee.allocation_evaluation, allocation_training: @grantee.allocation_training, conducted_training: @grantee.conducted_training, covid_interrupt_admin: @grantee.covid_interrupt_admin, covid_interrupt_service: @grantee.covid_interrupt_service, facil_trainers_developer: @grantee.facil_trainers_developer, facil_trainers_eval_partner: @grantee.facil_trainers_eval_partner, facil_trainers_grantee: @grantee.facil_trainers_grantee, facil_trainers_prog_provider: @grantee.facil_trainers_prog_provider, facil_trainers_tta_partner: @grantee.facil_trainers_tta_partner, observed_delivery: @grantee.observed_delivery, observers_developer: @grantee.observers_developer, observers_eval_partner: @grantee.observers_eval_partner, observers_grantee: @grantee.observers_grantee, observers_prog_provider: @grantee.observers_prog_provider, observers_tta_partner: @grantee.observers_tta_partner, period: @grantee.period, provided_tta: @grantee.provided_tta, staffing_covid_vacancies_ever: @grantee.staffing_covid_vacancies_ever, staffing_covid_vacancies_filled: @grantee.staffing_covid_vacancies_filled, staffing_fte_covid_vacancies_ever: @grantee.staffing_fte_covid_vacancies_ever, staffing_fte_covid_vacancies_filled: @grantee.staffing_fte_covid_vacancies_filled, staffing_fte_overseeing: @grantee.staffing_fte_overseeing, staffing_overseeing: @grantee.staffing_overseeing, total_grantee_award: @grantee.total_grantee_award, tta_providers_developer: @grantee.tta_providers_developer, tta_providers_eval_partner: @grantee.tta_providers_eval_partner, tta_providers_grantee: @grantee.tta_providers_grantee, tta_providers_prog_provider: @grantee.tta_providers_prog_provider, tta_providers_tta_partner: @grantee.tta_providers_tta_partner } }
    end

    assert_redirected_to grantee_url(Grantee.last)
  end

  test "should show grantee" do
    get grantee_url(@grantee)
    assert_response :success
  end

  test "should get edit" do
    get edit_grantee_url(@grantee)
    assert_response :success
  end

  test "should update grantee" do
    patch grantee_url(@grantee), params: { grantee: { allocation_administrative: @grantee.allocation_administrative, allocation_direct_service: @grantee.allocation_direct_service, allocation_evaluation: @grantee.allocation_evaluation, allocation_training: @grantee.allocation_training, conducted_training: @grantee.conducted_training, covid_interrupt_admin: @grantee.covid_interrupt_admin, covid_interrupt_service: @grantee.covid_interrupt_service, facil_trainers_developer: @grantee.facil_trainers_developer, facil_trainers_eval_partner: @grantee.facil_trainers_eval_partner, facil_trainers_grantee: @grantee.facil_trainers_grantee, facil_trainers_prog_provider: @grantee.facil_trainers_prog_provider, facil_trainers_tta_partner: @grantee.facil_trainers_tta_partner, observed_delivery: @grantee.observed_delivery, observers_developer: @grantee.observers_developer, observers_eval_partner: @grantee.observers_eval_partner, observers_grantee: @grantee.observers_grantee, observers_prog_provider: @grantee.observers_prog_provider, observers_tta_partner: @grantee.observers_tta_partner, period: @grantee.period, provided_tta: @grantee.provided_tta, staffing_covid_vacancies_ever: @grantee.staffing_covid_vacancies_ever, staffing_covid_vacancies_filled: @grantee.staffing_covid_vacancies_filled, staffing_fte_covid_vacancies_ever: @grantee.staffing_fte_covid_vacancies_ever, staffing_fte_covid_vacancies_filled: @grantee.staffing_fte_covid_vacancies_filled, staffing_fte_overseeing: @grantee.staffing_fte_overseeing, staffing_overseeing: @grantee.staffing_overseeing, total_grantee_award: @grantee.total_grantee_award, tta_providers_developer: @grantee.tta_providers_developer, tta_providers_eval_partner: @grantee.tta_providers_eval_partner, tta_providers_grantee: @grantee.tta_providers_grantee, tta_providers_prog_provider: @grantee.tta_providers_prog_provider, tta_providers_tta_partner: @grantee.tta_providers_tta_partner } }
    assert_redirected_to grantee_url(@grantee)
  end

  test "should destroy grantee" do
    assert_difference('Grantee.count', -1) do
      delete grantee_url(@grantee)
    end

    assert_redirected_to grantees_url
  end
end
