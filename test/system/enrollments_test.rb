require "application_system_test_case"

class EnrollmentsTest < ApplicationSystemTestCase
  setup do
    @enrollment = enrollments(:one)
  end

  test "visiting the index" do
    visit enrollments_url
    assert_selector "h1", text: "Enrollments"
  end

  test "creating a Enrollment" do
    visit enrollments_url
    click_on "New Enrollment"

    fill_in "Cohort", with: @enrollment.cohort
    fill_in "Name first", with: @enrollment.name_first
    fill_in "Name last", with: @enrollment.name_last
    fill_in "Name pref", with: @enrollment.name_pref
    check "Needs perm" if @enrollment.needs_perm
    check "Perm prog" if @enrollment.perm_prog
    check "Perm surveys" if @enrollment.perm_surveys
    check "Trashed" if @enrollment.trashed
    click_on "Create Enrollment"

    assert_text "Enrollment was successfully created"
    click_on "Back"
  end

  test "updating a Enrollment" do
    visit enrollments_url
    click_on "Edit", match: :first

    fill_in "Cohort", with: @enrollment.cohort
    fill_in "Name first", with: @enrollment.name_first
    fill_in "Name last", with: @enrollment.name_last
    fill_in "Name pref", with: @enrollment.name_pref
    check "Needs perm" if @enrollment.needs_perm
    check "Perm prog" if @enrollment.perm_prog
    check "Perm surveys" if @enrollment.perm_surveys
    check "Trashed" if @enrollment.trashed
    click_on "Update Enrollment"

    assert_text "Enrollment was successfully updated"
    click_on "Back"
  end

  test "destroying a Enrollment" do
    visit enrollments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Enrollment was successfully destroyed"
  end
end
