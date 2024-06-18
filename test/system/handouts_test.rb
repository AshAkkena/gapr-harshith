require "application_system_test_case"

class HandoutsTest < ApplicationSystemTestCase
  setup do
    @handout = handouts(:one)
  end

  test "visiting the index" do
    visit handouts_url
    assert_selector "h1", text: "Handouts"
  end

  test "creating a Handout" do
    visit handouts_url
    click_on "New Handout"

    fill_in "Description", with: @handout.description
    fill_in "Title", with: @handout.title
    click_on "Create Handout"

    assert_text "Handout was successfully created"
    click_on "Back"
  end

  test "updating a Handout" do
    visit handouts_url
    click_on "Edit", match: :first

    fill_in "Description", with: @handout.description
    fill_in "Title", with: @handout.title
    click_on "Update Handout"

    assert_text "Handout was successfully updated"
    click_on "Back"
  end

  test "destroying a Handout" do
    visit handouts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Handout was successfully destroyed"
  end
end
