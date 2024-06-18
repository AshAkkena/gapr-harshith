require "application_system_test_case"

class CohoDownsTest < ApplicationSystemTestCase
  setup do
    @coho_down = coho_downs(:one)
  end

  test "visiting the index" do
    visit coho_downs_url
    assert_selector "h1", text: "Coho Downs"
  end

  test "creating a Coho down" do
    visit coho_downs_url
    click_on "New Coho Down"

    fill_in "Census adjudication", with: @coho_down.census_adjudication
    fill_in "Census foster", with: @coho_down.census_foster
    fill_in "Census homeless", with: @coho_down.census_homeless
    fill_in "Census pregnant parenting", with: @coho_down.census_pregnant_parenting
    fill_in "Cohort", with: @coho_down.cohort_id
    check "Covid virtualization" if @coho_down.covid_virtualization
    fill_in "Main setting", with: @coho_down.main_setting
    check "Program complete" if @coho_down.program_complete
    fill_in "Total graduated hs", with: @coho_down.total_graduated_hs
    fill_in "Total graduated ms", with: @coho_down.total_graduated_ms
    fill_in "Total hours delivered", with: @coho_down.total_hours_delivered
    fill_in "Total initiated hs", with: @coho_down.total_initiated_hs
    fill_in "Total initiated ms", with: @coho_down.total_initiated_ms
    click_on "Create Coho down"

    assert_text "Coho down was successfully created"
    click_on "Back"
  end

  test "updating a Coho down" do
    visit coho_downs_url
    click_on "Edit", match: :first

    fill_in "Census adjudication", with: @coho_down.census_adjudication
    fill_in "Census foster", with: @coho_down.census_foster
    fill_in "Census homeless", with: @coho_down.census_homeless
    fill_in "Census pregnant parenting", with: @coho_down.census_pregnant_parenting
    fill_in "Cohort", with: @coho_down.cohort_id
    check "Covid virtualization" if @coho_down.covid_virtualization
    fill_in "Main setting", with: @coho_down.main_setting
    check "Program complete" if @coho_down.program_complete
    fill_in "Total graduated hs", with: @coho_down.total_graduated_hs
    fill_in "Total graduated ms", with: @coho_down.total_graduated_ms
    fill_in "Total hours delivered", with: @coho_down.total_hours_delivered
    fill_in "Total initiated hs", with: @coho_down.total_initiated_hs
    fill_in "Total initiated ms", with: @coho_down.total_initiated_ms
    click_on "Update Coho down"

    assert_text "Coho down was successfully updated"
    click_on "Back"
  end

  test "destroying a Coho down" do
    visit coho_downs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coho down was successfully destroyed"
  end
end
