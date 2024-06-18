require "application_system_test_case"

class IncentivesTest < ApplicationSystemTestCase
  setup do
    @incentive = incentives(:one)
  end

  test "visiting the index" do
    visit incentives_url
    assert_selector "h1", text: "Incentives"
  end

  test "creating a Incentive" do
    visit incentives_url
    click_on "New Incentive"

    fill_in "Fingerprint", with: @incentive.fingerprint
    fill_in "Period", with: @incentive.period
    click_on "Create Incentive"

    assert_text "Incentive was successfully created"
    click_on "Back"
  end

  test "updating a Incentive" do
    visit incentives_url
    click_on "Edit", match: :first

    fill_in "Fingerprint", with: @incentive.fingerprint
    fill_in "Period", with: @incentive.period
    click_on "Update Incentive"

    assert_text "Incentive was successfully updated"
    click_on "Back"
  end

  test "destroying a Incentive" do
    visit incentives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Incentive was successfully destroyed"
  end
end
