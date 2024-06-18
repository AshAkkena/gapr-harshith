require "application_system_test_case"

class CohoDownAttendsTest < ApplicationSystemTestCase
  setup do
    @coho_down_attend = coho_down_attends(:one)
  end

  test "visiting the index" do
    visit coho_down_attends_url
    assert_selector "h1", text: "Coho Down Attends"
  end

  test "creating a Coho down attend" do
    visit coho_down_attends_url
    click_on "New Coho Down Attend"

    fill_in "Cohort", with: @coho_down_attend.cohort_id
    fill_in "Happened on", with: @coho_down_attend.happened_on
    fill_in "Highschool headcount", with: @coho_down_attend.highschool_headcount
    fill_in "Middleschool headcount", with: @coho_down_attend.middleschool_headcount
    fill_in "Newface hs headcount", with: @coho_down_attend.newface_hs_headcount
    fill_in "Newface ms headcount", with: @coho_down_attend.newface_ms_headcount
    click_on "Create Coho down attend"

    assert_text "Coho down attend was successfully created"
    click_on "Back"
  end

  test "updating a Coho down attend" do
    visit coho_down_attends_url
    click_on "Edit", match: :first

    fill_in "Cohort", with: @coho_down_attend.cohort_id
    fill_in "Happened on", with: @coho_down_attend.happened_on
    fill_in "Highschool headcount", with: @coho_down_attend.highschool_headcount
    fill_in "Middleschool headcount", with: @coho_down_attend.middleschool_headcount
    fill_in "Newface hs headcount", with: @coho_down_attend.newface_hs_headcount
    fill_in "Newface ms headcount", with: @coho_down_attend.newface_ms_headcount
    click_on "Update Coho down attend"

    assert_text "Coho down attend was successfully updated"
    click_on "Back"
  end

  test "destroying a Coho down attend" do
    visit coho_down_attends_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coho down attend was successfully destroyed"
  end
end
