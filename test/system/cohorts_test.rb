require "application_system_test_case"

class CohortsTest < ApplicationSystemTestCase
  setup do
    @cohort = cohorts(:one)
  end

  test "visiting the index" do
    visit cohorts_url
    assert_selector "h1", text: "Cohorts"
  end

  test "creating a Cohort" do
    visit cohorts_url
    click_on "New Cohort"

    check "Adolescent development material add curr adhoc" if @cohort.adolescent_development_material_add_curr_adhoc
    check "Adolescent development material add curr entirely" if @cohort.adolescent_development_material_add_curr_entirely
    check "Adolescent development material evidence based" if @cohort.adolescent_development_material_evidence_based
    check "Adolescent development material original content" if @cohort.adolescent_development_material_original_content
    check "Covered adolescent development" if @cohort.covered_adolescent_development
    check "Covered edu career success" if @cohort.covered_edu_career_success
    check "Covered financial literacy" if @cohort.covered_financial_literacy
    check "Covered healthy life skills" if @cohort.covered_healthy_life_skills
    check "Covered healthy relationship" if @cohort.covered_healthy_relationship
    check "Covered par child comm" if @cohort.covered_par_child_comm
    fill_in "Curriculum choice", with: @cohort.curriculum_choice
    check "Edu career success material add curr adhoc" if @cohort.edu_career_success_material_add_curr_adhoc
    check "Edu career success material add curr entirely" if @cohort.edu_career_success_material_add_curr_entirely
    check "Edu career success material evidence based" if @cohort.edu_career_success_material_evidence_based
    check "Edu career success material original content" if @cohort.edu_career_success_material_original_content
    check "Financial literacy material add curr adhoc" if @cohort.financial_literacy_material_add_curr_adhoc
    check "Financial literacy material add curr entirely" if @cohort.financial_literacy_material_add_curr_entirely
    check "Financial literacy material evidence based" if @cohort.financial_literacy_material_evidence_based
    check "Financial literacy material original content" if @cohort.financial_literacy_material_original_content
    check "Healthy life skills material add curr adhoc" if @cohort.healthy_life_skills_material_add_curr_adhoc
    check "Healthy life skills material add curr entirely" if @cohort.healthy_life_skills_material_add_curr_entirely
    check "Healthy life skills material evidence based" if @cohort.healthy_life_skills_material_evidence_based
    check "Healthy life skills material original content" if @cohort.healthy_life_skills_material_original_content
    check "Healthy relationship material add curr adhoc" if @cohort.healthy_relationship_material_add_curr_adhoc
    check "Healthy relationship material add curr entirely" if @cohort.healthy_relationship_material_add_curr_entirely
    check "Healthy relationship material evidence based" if @cohort.healthy_relationship_material_evidence_based
    check "Healthy relationship material original content" if @cohort.healthy_relationship_material_original_content
    fill_in "Intended finish", with: @cohort.intended_finish
    fill_in "Intended session count", with: @cohort.intended_session_count
    fill_in "Intended session duration minute", with: @cohort.intended_session_duration_minute
    fill_in "Intended setting", with: @cohort.intended_setting
    fill_in "Intended start", with: @cohort.intended_start
    check "Par child comm material add curr adhoc" if @cohort.par_child_comm_material_add_curr_adhoc
    check "Par child comm material add curr entirely" if @cohort.par_child_comm_material_add_curr_entirely
    check "Par child comm material evidence based" if @cohort.par_child_comm_material_evidence_based
    check "Par child comm material original content" if @cohort.par_child_comm_material_original_content
    fill_in "Period", with: @cohort.period
    fill_in "Provider", with: @cohort.provider_id
    check "Target adjudicated" if @cohort.target_adjudicated
    check "Target african american" if @cohort.target_african_american
    check "Target dropout" if @cohort.target_dropout
    check "Target foster" if @cohort.target_foster
    check "Target highneed geo" if @cohort.target_highneed_geo
    check "Target hiv aids" if @cohort.target_hiv_aids
    check "Target homeless runaway" if @cohort.target_homeless_runaway
    check "Target latino" if @cohort.target_latino
    check "Target male" if @cohort.target_male
    check "Target mental health" if @cohort.target_mental_health
    check "Target native american" if @cohort.target_native_american
    check "Target pregnant parenting" if @cohort.target_pregnant_parenting
    check "Target trafficked" if @cohort.target_trafficked
    click_on "Create Cohort"

    assert_text "Cohort was successfully created"
    click_on "Back"
  end

  test "updating a Cohort" do
    visit cohorts_url
    click_on "Edit", match: :first

    check "Adolescent development material add curr adhoc" if @cohort.adolescent_development_material_add_curr_adhoc
    check "Adolescent development material add curr entirely" if @cohort.adolescent_development_material_add_curr_entirely
    check "Adolescent development material evidence based" if @cohort.adolescent_development_material_evidence_based
    check "Adolescent development material original content" if @cohort.adolescent_development_material_original_content
    check "Covered adolescent development" if @cohort.covered_adolescent_development
    check "Covered edu career success" if @cohort.covered_edu_career_success
    check "Covered financial literacy" if @cohort.covered_financial_literacy
    check "Covered healthy life skills" if @cohort.covered_healthy_life_skills
    check "Covered healthy relationship" if @cohort.covered_healthy_relationship
    check "Covered par child comm" if @cohort.covered_par_child_comm
    fill_in "Curriculum choice", with: @cohort.curriculum_choice
    check "Edu career success material add curr adhoc" if @cohort.edu_career_success_material_add_curr_adhoc
    check "Edu career success material add curr entirely" if @cohort.edu_career_success_material_add_curr_entirely
    check "Edu career success material evidence based" if @cohort.edu_career_success_material_evidence_based
    check "Edu career success material original content" if @cohort.edu_career_success_material_original_content
    check "Financial literacy material add curr adhoc" if @cohort.financial_literacy_material_add_curr_adhoc
    check "Financial literacy material add curr entirely" if @cohort.financial_literacy_material_add_curr_entirely
    check "Financial literacy material evidence based" if @cohort.financial_literacy_material_evidence_based
    check "Financial literacy material original content" if @cohort.financial_literacy_material_original_content
    check "Healthy life skills material add curr adhoc" if @cohort.healthy_life_skills_material_add_curr_adhoc
    check "Healthy life skills material add curr entirely" if @cohort.healthy_life_skills_material_add_curr_entirely
    check "Healthy life skills material evidence based" if @cohort.healthy_life_skills_material_evidence_based
    check "Healthy life skills material original content" if @cohort.healthy_life_skills_material_original_content
    check "Healthy relationship material add curr adhoc" if @cohort.healthy_relationship_material_add_curr_adhoc
    check "Healthy relationship material add curr entirely" if @cohort.healthy_relationship_material_add_curr_entirely
    check "Healthy relationship material evidence based" if @cohort.healthy_relationship_material_evidence_based
    check "Healthy relationship material original content" if @cohort.healthy_relationship_material_original_content
    fill_in "Intended finish", with: @cohort.intended_finish
    fill_in "Intended session count", with: @cohort.intended_session_count
    fill_in "Intended session duration minute", with: @cohort.intended_session_duration_minute
    fill_in "Intended setting", with: @cohort.intended_setting
    fill_in "Intended start", with: @cohort.intended_start
    check "Par child comm material add curr adhoc" if @cohort.par_child_comm_material_add_curr_adhoc
    check "Par child comm material add curr entirely" if @cohort.par_child_comm_material_add_curr_entirely
    check "Par child comm material evidence based" if @cohort.par_child_comm_material_evidence_based
    check "Par child comm material original content" if @cohort.par_child_comm_material_original_content
    fill_in "Period", with: @cohort.period
    fill_in "Provider", with: @cohort.provider_id
    check "Target adjudicated" if @cohort.target_adjudicated
    check "Target african american" if @cohort.target_african_american
    check "Target dropout" if @cohort.target_dropout
    check "Target foster" if @cohort.target_foster
    check "Target highneed geo" if @cohort.target_highneed_geo
    check "Target hiv aids" if @cohort.target_hiv_aids
    check "Target homeless runaway" if @cohort.target_homeless_runaway
    check "Target latino" if @cohort.target_latino
    check "Target male" if @cohort.target_male
    check "Target mental health" if @cohort.target_mental_health
    check "Target native american" if @cohort.target_native_american
    check "Target pregnant parenting" if @cohort.target_pregnant_parenting
    check "Target trafficked" if @cohort.target_trafficked
    click_on "Update Cohort"

    assert_text "Cohort was successfully updated"
    click_on "Back"
  end

  test "destroying a Cohort" do
    visit cohorts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cohort was successfully destroyed"
  end
end
