require "test_helper"

class CohortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cohort = cohorts(:one)
  end

  test "should get index" do
    get cohorts_url
    assert_response :success
  end

  test "should get new" do
    get new_cohort_url
    assert_response :success
  end

  test "should create cohort" do
    assert_difference('Cohort.count') do
      post cohorts_url, params: { cohort: { adolescent_development_material_add_curr_adhoc: @cohort.adolescent_development_material_add_curr_adhoc, adolescent_development_material_add_curr_entirely: @cohort.adolescent_development_material_add_curr_entirely, adolescent_development_material_evidence_based: @cohort.adolescent_development_material_evidence_based, adolescent_development_material_original_content: @cohort.adolescent_development_material_original_content, covered_adolescent_development: @cohort.covered_adolescent_development, covered_edu_career_success: @cohort.covered_edu_career_success, covered_financial_literacy: @cohort.covered_financial_literacy, covered_healthy_life_skills: @cohort.covered_healthy_life_skills, covered_healthy_relationship: @cohort.covered_healthy_relationship, covered_par_child_comm: @cohort.covered_par_child_comm, curriculum_choice: @cohort.curriculum_choice, edu_career_success_material_add_curr_adhoc: @cohort.edu_career_success_material_add_curr_adhoc, edu_career_success_material_add_curr_entirely: @cohort.edu_career_success_material_add_curr_entirely, edu_career_success_material_evidence_based: @cohort.edu_career_success_material_evidence_based, edu_career_success_material_original_content: @cohort.edu_career_success_material_original_content, financial_literacy_material_add_curr_adhoc: @cohort.financial_literacy_material_add_curr_adhoc, financial_literacy_material_add_curr_entirely: @cohort.financial_literacy_material_add_curr_entirely, financial_literacy_material_evidence_based: @cohort.financial_literacy_material_evidence_based, financial_literacy_material_original_content: @cohort.financial_literacy_material_original_content, healthy_life_skills_material_add_curr_adhoc: @cohort.healthy_life_skills_material_add_curr_adhoc, healthy_life_skills_material_add_curr_entirely: @cohort.healthy_life_skills_material_add_curr_entirely, healthy_life_skills_material_evidence_based: @cohort.healthy_life_skills_material_evidence_based, healthy_life_skills_material_original_content: @cohort.healthy_life_skills_material_original_content, healthy_relationship_material_add_curr_adhoc: @cohort.healthy_relationship_material_add_curr_adhoc, healthy_relationship_material_add_curr_entirely: @cohort.healthy_relationship_material_add_curr_entirely, healthy_relationship_material_evidence_based: @cohort.healthy_relationship_material_evidence_based, healthy_relationship_material_original_content: @cohort.healthy_relationship_material_original_content, intended_finish: @cohort.intended_finish, intended_session_count: @cohort.intended_session_count, intended_session_duration_minute: @cohort.intended_session_duration_minute, intended_setting: @cohort.intended_setting, intended_start: @cohort.intended_start, par_child_comm_material_add_curr_adhoc: @cohort.par_child_comm_material_add_curr_adhoc, par_child_comm_material_add_curr_entirely: @cohort.par_child_comm_material_add_curr_entirely, par_child_comm_material_evidence_based: @cohort.par_child_comm_material_evidence_based, par_child_comm_material_original_content: @cohort.par_child_comm_material_original_content, period: @cohort.period, provider_id: @cohort.provider_id, target_adjudicated: @cohort.target_adjudicated, target_african_american: @cohort.target_african_american, target_dropout: @cohort.target_dropout, target_foster: @cohort.target_foster, target_highneed_geo: @cohort.target_highneed_geo, target_hiv_aids: @cohort.target_hiv_aids, target_homeless_runaway: @cohort.target_homeless_runaway, target_latino: @cohort.target_latino, target_male: @cohort.target_male, target_mental_health: @cohort.target_mental_health, target_native_american: @cohort.target_native_american, target_pregnant_parenting: @cohort.target_pregnant_parenting, target_trafficked: @cohort.target_trafficked } }
    end

    assert_redirected_to cohort_url(Cohort.last)
  end

  test "should show cohort" do
    get cohort_url(@cohort)
    assert_response :success
  end

  test "should get edit" do
    get edit_cohort_url(@cohort)
    assert_response :success
  end

  test "should update cohort" do
    patch cohort_url(@cohort), params: { cohort: { adolescent_development_material_add_curr_adhoc: @cohort.adolescent_development_material_add_curr_adhoc, adolescent_development_material_add_curr_entirely: @cohort.adolescent_development_material_add_curr_entirely, adolescent_development_material_evidence_based: @cohort.adolescent_development_material_evidence_based, adolescent_development_material_original_content: @cohort.adolescent_development_material_original_content, covered_adolescent_development: @cohort.covered_adolescent_development, covered_edu_career_success: @cohort.covered_edu_career_success, covered_financial_literacy: @cohort.covered_financial_literacy, covered_healthy_life_skills: @cohort.covered_healthy_life_skills, covered_healthy_relationship: @cohort.covered_healthy_relationship, covered_par_child_comm: @cohort.covered_par_child_comm, curriculum_choice: @cohort.curriculum_choice, edu_career_success_material_add_curr_adhoc: @cohort.edu_career_success_material_add_curr_adhoc, edu_career_success_material_add_curr_entirely: @cohort.edu_career_success_material_add_curr_entirely, edu_career_success_material_evidence_based: @cohort.edu_career_success_material_evidence_based, edu_career_success_material_original_content: @cohort.edu_career_success_material_original_content, financial_literacy_material_add_curr_adhoc: @cohort.financial_literacy_material_add_curr_adhoc, financial_literacy_material_add_curr_entirely: @cohort.financial_literacy_material_add_curr_entirely, financial_literacy_material_evidence_based: @cohort.financial_literacy_material_evidence_based, financial_literacy_material_original_content: @cohort.financial_literacy_material_original_content, healthy_life_skills_material_add_curr_adhoc: @cohort.healthy_life_skills_material_add_curr_adhoc, healthy_life_skills_material_add_curr_entirely: @cohort.healthy_life_skills_material_add_curr_entirely, healthy_life_skills_material_evidence_based: @cohort.healthy_life_skills_material_evidence_based, healthy_life_skills_material_original_content: @cohort.healthy_life_skills_material_original_content, healthy_relationship_material_add_curr_adhoc: @cohort.healthy_relationship_material_add_curr_adhoc, healthy_relationship_material_add_curr_entirely: @cohort.healthy_relationship_material_add_curr_entirely, healthy_relationship_material_evidence_based: @cohort.healthy_relationship_material_evidence_based, healthy_relationship_material_original_content: @cohort.healthy_relationship_material_original_content, intended_finish: @cohort.intended_finish, intended_session_count: @cohort.intended_session_count, intended_session_duration_minute: @cohort.intended_session_duration_minute, intended_setting: @cohort.intended_setting, intended_start: @cohort.intended_start, par_child_comm_material_add_curr_adhoc: @cohort.par_child_comm_material_add_curr_adhoc, par_child_comm_material_add_curr_entirely: @cohort.par_child_comm_material_add_curr_entirely, par_child_comm_material_evidence_based: @cohort.par_child_comm_material_evidence_based, par_child_comm_material_original_content: @cohort.par_child_comm_material_original_content, period: @cohort.period, provider_id: @cohort.provider_id, target_adjudicated: @cohort.target_adjudicated, target_african_american: @cohort.target_african_american, target_dropout: @cohort.target_dropout, target_foster: @cohort.target_foster, target_highneed_geo: @cohort.target_highneed_geo, target_hiv_aids: @cohort.target_hiv_aids, target_homeless_runaway: @cohort.target_homeless_runaway, target_latino: @cohort.target_latino, target_male: @cohort.target_male, target_mental_health: @cohort.target_mental_health, target_native_american: @cohort.target_native_american, target_pregnant_parenting: @cohort.target_pregnant_parenting, target_trafficked: @cohort.target_trafficked } }
    assert_redirected_to cohort_url(@cohort)
  end

  test "should destroy cohort" do
    assert_difference('Cohort.count', -1) do
      delete cohort_url(@cohort)
    end

    assert_redirected_to cohorts_url
  end
end
