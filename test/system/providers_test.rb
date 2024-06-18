require "application_system_test_case"

class ProvidersTest < ApplicationSystemTestCase
  setup do
    @provider = providers(:one)
  end

  test "visiting the index" do
    visit providers_url
    assert_selector "h1", text: "Providers"
  end

  test "creating a Provider" do
    visit providers_url
    click_on "New Provider"

    fill_in "Award amount", with: @provider.award_amount
    fill_in "Challenges attendance", with: @provider.challenges_attendance
    fill_in "Challenges covering content", with: @provider.challenges_covering_content
    fill_in "Challenges engagement", with: @provider.challenges_engagement
    fill_in "Challenges facilities", with: @provider.challenges_facilities
    fill_in "Challenges natural disasters", with: @provider.challenges_natural_disasters
    fill_in "Challenges negative peer interactions", with: @provider.challenges_negative_peer_interactions
    fill_in "Challenges recruiting staff", with: @provider.challenges_recruiting_staff
    fill_in "Challenges recruiting youth", with: @provider.challenges_recruiting_youth
    fill_in "Challenges staff understanding", with: @provider.challenges_staff_understanding
    fill_in "Challenges stakeholder support", with: @provider.challenges_stakeholder_support
    fill_in "Challenges turnover", with: @provider.challenges_turnover
    fill_in "Challenges youth behavioral", with: @provider.challenges_youth_behavioral
    fill_in "Facilitators covid vacancies ever", with: @provider.facilitators_covid_vacancies_ever
    fill_in "Facilitators covid vacancies filled", with: @provider.facilitators_covid_vacancies_filled
    fill_in "Facilitators observed just once", with: @provider.facilitators_observed_just_once
    fill_in "Facilitators observed twice more", with: @provider.facilitators_observed_twice_more
    fill_in "Facilitators total", with: @provider.facilitators_total
    fill_in "Facilitators trained core model", with: @provider.facilitators_trained_core_model
    fill_in "Nonprep funding", with: @provider.nonprep_funding
    fill_in "Period", with: @provider.period
    fill_in "Pmms aggregate name", with: @provider.pmms_aggregate_name
    check "Provider new" if @provider.provider_new
    check "Provider served youth" if @provider.provider_served_youth
    fill_in "Staffing administering", with: @provider.staffing_administering
    fill_in "Staffing administrative covid vacancies ever", with: @provider.staffing_administrative_covid_vacancies_ever
    fill_in "Staffing administrative covid vacancies filled", with: @provider.staffing_administrative_covid_vacancies_filled
    fill_in "Staffing fte administering", with: @provider.staffing_fte_administering
    fill_in "Staffing fte administering covid vacancies ever", with: @provider.staffing_fte_administering_covid_vacancies_ever
    fill_in "Staffing fte administering covid vacancies filled", with: @provider.staffing_fte_administering_covid_vacancies_filled
    fill_in "Tta addressing behavior", with: @provider.tta_addressing_behavior
    fill_in "Tta attendance", with: @provider.tta_attendance
    fill_in "Tta engagement", with: @provider.tta_engagement
    fill_in "Tta evaluation", with: @provider.tta_evaluation
    fill_in "Tta minimize negative peer", with: @provider.tta_minimize_negative_peer
    fill_in "Tta obtaining support", with: @provider.tta_obtaining_support
    fill_in "Tta other rating", with: @provider.tta_other_rating
    fill_in "Tta other text", with: @provider.tta_other_text
    fill_in "Tta parent support", with: @provider.tta_parent_support
    fill_in "Tta recruiting staff", with: @provider.tta_recruiting_staff
    fill_in "Tta recruiting youth", with: @provider.tta_recruiting_youth
    fill_in "Tta retaining staff", with: @provider.tta_retaining_staff
    fill_in "Tta training facilitators", with: @provider.tta_training_facilitators
    click_on "Create Provider"

    assert_text "Provider was successfully created"
    click_on "Back"
  end

  test "updating a Provider" do
    visit providers_url
    click_on "Edit", match: :first

    fill_in "Award amount", with: @provider.award_amount
    fill_in "Challenges attendance", with: @provider.challenges_attendance
    fill_in "Challenges covering content", with: @provider.challenges_covering_content
    fill_in "Challenges engagement", with: @provider.challenges_engagement
    fill_in "Challenges facilities", with: @provider.challenges_facilities
    fill_in "Challenges natural disasters", with: @provider.challenges_natural_disasters
    fill_in "Challenges negative peer interactions", with: @provider.challenges_negative_peer_interactions
    fill_in "Challenges recruiting staff", with: @provider.challenges_recruiting_staff
    fill_in "Challenges recruiting youth", with: @provider.challenges_recruiting_youth
    fill_in "Challenges staff understanding", with: @provider.challenges_staff_understanding
    fill_in "Challenges stakeholder support", with: @provider.challenges_stakeholder_support
    fill_in "Challenges turnover", with: @provider.challenges_turnover
    fill_in "Challenges youth behavioral", with: @provider.challenges_youth_behavioral
    fill_in "Facilitators covid vacancies ever", with: @provider.facilitators_covid_vacancies_ever
    fill_in "Facilitators covid vacancies filled", with: @provider.facilitators_covid_vacancies_filled
    fill_in "Facilitators observed just once", with: @provider.facilitators_observed_just_once
    fill_in "Facilitators observed twice more", with: @provider.facilitators_observed_twice_more
    fill_in "Facilitators total", with: @provider.facilitators_total
    fill_in "Facilitators trained core model", with: @provider.facilitators_trained_core_model
    fill_in "Nonprep funding", with: @provider.nonprep_funding
    fill_in "Period", with: @provider.period
    fill_in "Pmms aggregate name", with: @provider.pmms_aggregate_name
    check "Provider new" if @provider.provider_new
    check "Provider served youth" if @provider.provider_served_youth
    fill_in "Staffing administering", with: @provider.staffing_administering
    fill_in "Staffing administrative covid vacancies ever", with: @provider.staffing_administrative_covid_vacancies_ever
    fill_in "Staffing administrative covid vacancies filled", with: @provider.staffing_administrative_covid_vacancies_filled
    fill_in "Staffing fte administering", with: @provider.staffing_fte_administering
    fill_in "Staffing fte administering covid vacancies ever", with: @provider.staffing_fte_administering_covid_vacancies_ever
    fill_in "Staffing fte administering covid vacancies filled", with: @provider.staffing_fte_administering_covid_vacancies_filled
    fill_in "Tta addressing behavior", with: @provider.tta_addressing_behavior
    fill_in "Tta attendance", with: @provider.tta_attendance
    fill_in "Tta engagement", with: @provider.tta_engagement
    fill_in "Tta evaluation", with: @provider.tta_evaluation
    fill_in "Tta minimize negative peer", with: @provider.tta_minimize_negative_peer
    fill_in "Tta obtaining support", with: @provider.tta_obtaining_support
    fill_in "Tta other rating", with: @provider.tta_other_rating
    fill_in "Tta other text", with: @provider.tta_other_text
    fill_in "Tta parent support", with: @provider.tta_parent_support
    fill_in "Tta recruiting staff", with: @provider.tta_recruiting_staff
    fill_in "Tta recruiting youth", with: @provider.tta_recruiting_youth
    fill_in "Tta retaining staff", with: @provider.tta_retaining_staff
    fill_in "Tta training facilitators", with: @provider.tta_training_facilitators
    click_on "Update Provider"

    assert_text "Provider was successfully updated"
    click_on "Back"
  end

  test "destroying a Provider" do
    visit providers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Provider was successfully destroyed"
  end
end
