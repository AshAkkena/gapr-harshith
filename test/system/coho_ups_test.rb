require "application_system_test_case"

class CohoUpsTest < ApplicationSystemTestCase
  setup do
    @coho_up = coho_ups(:one)
  end

  test "visiting the index" do
    visit coho_ups_url
    assert_selector "h1", text: "Coho Ups"
  end

  test "creating a Coho up" do
    visit coho_ups_url
    click_on "New Coho Up"

    fill_in "Cohort", with: @coho_up.cohort_id
    fill_in "Magic code", with: @coho_up.magic_code
    click_on "Create Coho up"

    assert_text "Coho up was successfully created"
    click_on "Back"
  end

  test "updating a Coho up" do
    visit coho_ups_url
    click_on "Edit", match: :first

    fill_in "Cohort", with: @coho_up.cohort_id
    fill_in "Magic code", with: @coho_up.magic_code
    click_on "Update Coho up"

    assert_text "Coho up was successfully updated"
    click_on "Back"
  end

  test "destroying a Coho up" do
    visit coho_ups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coho up was successfully destroyed"
  end
end
