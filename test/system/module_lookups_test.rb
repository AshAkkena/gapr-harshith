require "application_system_test_case"

class ModuleLookupsTest < ApplicationSystemTestCase
  setup do
    @module_lookup = module_lookups(:one)
  end

  test "visiting the index" do
    visit module_lookups_url
    assert_selector "h1", text: "Module Lookups"
  end

  test "creating a Module lookup" do
    visit module_lookups_url
    click_on "New Module Lookup"

    fill_in "Abbreviated curriculum", with: @module_lookup.abbreviated_curriculum
    fill_in "Basic name", with: @module_lookup.basic_name
    fill_in "Delivery sequence", with: @module_lookup.delivery_sequence
    fill_in "Period", with: @module_lookup.period
    click_on "Create Module lookup"

    assert_text "Module lookup was successfully created"
    click_on "Back"
  end

  test "updating a Module lookup" do
    visit module_lookups_url
    click_on "Edit", match: :first

    fill_in "Abbreviated curriculum", with: @module_lookup.abbreviated_curriculum
    fill_in "Basic name", with: @module_lookup.basic_name
    fill_in "Delivery sequence", with: @module_lookup.delivery_sequence
    fill_in "Period", with: @module_lookup.period
    click_on "Update Module lookup"

    assert_text "Module lookup was successfully updated"
    click_on "Back"
  end

  test "destroying a Module lookup" do
    visit module_lookups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Module lookup was successfully destroyed"
  end
end
