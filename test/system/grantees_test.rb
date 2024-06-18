require "application_system_test_case"

class GranteesTest < ApplicationSystemTestCase
  setup do
    @grantee = grantees(:one)
  end

  test "visiting the index" do
    visit grantees_url
    assert_selector "h1", text: "Grantees"
  end

  test "creating a Grantee" do
    visit grantees_url
    click_on "New Grantee"

    fill_in "Allocation administrative", with: @grantee.allocation_administrative
    fill_in "Allocation direct service", with: @grantee.allocation_direct_service
    fill_in "Allocation evaluation", with: @grantee.allocation_evaluation
    fill_in "Allocation training", with: @grantee.allocation_training
    check "Conducted training" if @grantee.conducted_training
    check "Covid interrupt admin" if @grantee.covid_interrupt_admin
    check "Covid interrupt service" if @grantee.covid_interrupt_service
    check "Facil trainers developer" if @grantee.facil_trainers_developer
    check "Facil trainers eval partner" if @grantee.facil_trainers_eval_partner
    check "Facil trainers grantee" if @grantee.facil_trainers_grantee
    check "Facil trainers prog provider" if @grantee.facil_trainers_prog_provider
    check "Facil trainers tta partner" if @grantee.facil_trainers_tta_partner
    check "Observed delivery" if @grantee.observed_delivery
    check "Observers developer" if @grantee.observers_developer
    check "Observers eval partner" if @grantee.observers_eval_partner
    check "Observers grantee" if @grantee.observers_grantee
    check "Observers prog provider" if @grantee.observers_prog_provider
    check "Observers tta partner" if @grantee.observers_tta_partner
    fill_in "Period", with: @grantee.period
    check "Provided tta" if @grantee.provided_tta
    fill_in "Staffing covid vacancies ever", with: @grantee.staffing_covid_vacancies_ever
    fill_in "Staffing covid vacancies filled", with: @grantee.staffing_covid_vacancies_filled
    fill_in "Staffing fte covid vacancies ever", with: @grantee.staffing_fte_covid_vacancies_ever
    fill_in "Staffing fte covid vacancies filled", with: @grantee.staffing_fte_covid_vacancies_filled
    fill_in "Staffing fte overseeing", with: @grantee.staffing_fte_overseeing
    fill_in "Staffing overseeing", with: @grantee.staffing_overseeing
    fill_in "Total grantee award", with: @grantee.total_grantee_award
    check "Tta providers developer" if @grantee.tta_providers_developer
    check "Tta providers eval partner" if @grantee.tta_providers_eval_partner
    check "Tta providers grantee" if @grantee.tta_providers_grantee
    check "Tta providers prog provider" if @grantee.tta_providers_prog_provider
    check "Tta providers tta partner" if @grantee.tta_providers_tta_partner
    click_on "Create Grantee"

    assert_text "Grantee was successfully created"
    click_on "Back"
  end

  test "updating a Grantee" do
    visit grantees_url
    click_on "Edit", match: :first

    fill_in "Allocation administrative", with: @grantee.allocation_administrative
    fill_in "Allocation direct service", with: @grantee.allocation_direct_service
    fill_in "Allocation evaluation", with: @grantee.allocation_evaluation
    fill_in "Allocation training", with: @grantee.allocation_training
    check "Conducted training" if @grantee.conducted_training
    check "Covid interrupt admin" if @grantee.covid_interrupt_admin
    check "Covid interrupt service" if @grantee.covid_interrupt_service
    check "Facil trainers developer" if @grantee.facil_trainers_developer
    check "Facil trainers eval partner" if @grantee.facil_trainers_eval_partner
    check "Facil trainers grantee" if @grantee.facil_trainers_grantee
    check "Facil trainers prog provider" if @grantee.facil_trainers_prog_provider
    check "Facil trainers tta partner" if @grantee.facil_trainers_tta_partner
    check "Observed delivery" if @grantee.observed_delivery
    check "Observers developer" if @grantee.observers_developer
    check "Observers eval partner" if @grantee.observers_eval_partner
    check "Observers grantee" if @grantee.observers_grantee
    check "Observers prog provider" if @grantee.observers_prog_provider
    check "Observers tta partner" if @grantee.observers_tta_partner
    fill_in "Period", with: @grantee.period
    check "Provided tta" if @grantee.provided_tta
    fill_in "Staffing covid vacancies ever", with: @grantee.staffing_covid_vacancies_ever
    fill_in "Staffing covid vacancies filled", with: @grantee.staffing_covid_vacancies_filled
    fill_in "Staffing fte covid vacancies ever", with: @grantee.staffing_fte_covid_vacancies_ever
    fill_in "Staffing fte covid vacancies filled", with: @grantee.staffing_fte_covid_vacancies_filled
    fill_in "Staffing fte overseeing", with: @grantee.staffing_fte_overseeing
    fill_in "Staffing overseeing", with: @grantee.staffing_overseeing
    fill_in "Total grantee award", with: @grantee.total_grantee_award
    check "Tta providers developer" if @grantee.tta_providers_developer
    check "Tta providers eval partner" if @grantee.tta_providers_eval_partner
    check "Tta providers grantee" if @grantee.tta_providers_grantee
    check "Tta providers prog provider" if @grantee.tta_providers_prog_provider
    check "Tta providers tta partner" if @grantee.tta_providers_tta_partner
    click_on "Update Grantee"

    assert_text "Grantee was successfully updated"
    click_on "Back"
  end

  test "destroying a Grantee" do
    visit grantees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grantee was successfully destroyed"
  end
end
