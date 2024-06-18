# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_23_021239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "coho_down_attends", force: :cascade do |t|
    t.date "happened_on"
    t.integer "middleschool_headcount"
    t.integer "highschool_headcount"
    t.integer "newface_ms_headcount"
    t.integer "newface_hs_headcount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "coho_down_id", null: false
    t.index ["coho_down_id", "happened_on"], name: "index_coho_down_attends_on_coho_down_id_and_happened_on", unique: true
    t.index ["coho_down_id"], name: "index_coho_down_attends_on_coho_down_id"
  end

  create_table "coho_downs", force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.integer "total_graduated_ms"
    t.integer "total_graduated_hs"
    t.integer "total_initiated_ms"
    t.integer "total_initiated_hs"
    t.integer "total_hours_delivered"
    t.boolean "program_complete"
    t.integer "census_foster"
    t.integer "census_homeless"
    t.integer "census_pregnant_parenting"
    t.integer "census_adjudication"
    t.string "main_setting"
    t.boolean "covid_virtualization"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ppr_count_male", default: 0
    t.integer "ppr_count_female", default: 0
    t.integer "ppr_count_10_13", default: 0
    t.integer "ppr_count_14_19", default: 0
    t.integer "ppr_count_20", default: 0
    t.integer "ppr_count_preg_par", default: 0
    t.integer "ppr_count_juv_jus", default: 0
    t.integer "ppr_count_foster", default: 0
    t.integer "ppr_count_runaway", default: 0
    t.integer "ppr_count_lgbt", default: 0
    t.integer "ppr_count_total", default: 0
    t.string "rationale"
    t.index ["cohort_id"], name: "index_coho_downs_on_cohort_id"
  end

  create_table "coho_ups", force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.string "magic_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ppr_count_male", default: 0
    t.integer "ppr_count_female", default: 0
    t.integer "ppr_count_10_13", default: 0
    t.integer "ppr_count_14_19", default: 0
    t.integer "ppr_count_20", default: 0
    t.integer "ppr_count_preg_par", default: 0
    t.integer "ppr_count_juv_jus", default: 0
    t.integer "ppr_count_foster", default: 0
    t.integer "ppr_count_runaway", default: 0
    t.integer "ppr_count_lgbt", default: 0
    t.integer "ppr_count_total", default: 0
    t.string "link_entry"
    t.string "link_exit"
    t.index ["cohort_id"], name: "index_coho_ups_on_cohort_id"
  end

  create_table "cohorts", force: :cascade do |t|
    t.decimal "period", precision: 5, scale: 1
    t.bigint "provider_id", null: false
    t.string "curriculum_choice"
    t.date "intended_start"
    t.date "intended_finish"
    t.integer "intended_session_count"
    t.integer "intended_session_duration_minute"
    t.string "intended_setting"
    t.boolean "target_foster"
    t.boolean "target_homeless_runaway"
    t.boolean "target_hiv_aids"
    t.boolean "target_pregnant_parenting"
    t.boolean "target_latino"
    t.boolean "target_african_american"
    t.boolean "target_native_american"
    t.boolean "target_adjudicated"
    t.boolean "target_male"
    t.boolean "target_highneed_geo"
    t.boolean "target_dropout"
    t.boolean "target_mental_health"
    t.boolean "target_trafficked"
    t.boolean "covered_healthy_relationship"
    t.boolean "healthy_relationship_material_evidence_based"
    t.boolean "healthy_relationship_material_add_curr_entirely"
    t.boolean "healthy_relationship_material_add_curr_adhoc"
    t.boolean "healthy_relationship_material_original_content"
    t.boolean "covered_adolescent_development"
    t.boolean "adolescent_development_material_evidence_based"
    t.boolean "adolescent_development_material_add_curr_entirely"
    t.boolean "adolescent_development_material_add_curr_adhoc"
    t.boolean "adolescent_development_material_original_content"
    t.boolean "covered_financial_literacy"
    t.boolean "financial_literacy_material_evidence_based"
    t.boolean "financial_literacy_material_add_curr_entirely"
    t.boolean "financial_literacy_material_add_curr_adhoc"
    t.boolean "financial_literacy_material_original_content"
    t.boolean "covered_par_child_comm"
    t.boolean "par_child_comm_material_evidence_based"
    t.boolean "par_child_comm_material_add_curr_entirely"
    t.boolean "par_child_comm_material_add_curr_adhoc"
    t.boolean "par_child_comm_material_original_content"
    t.boolean "covered_edu_career_success"
    t.boolean "edu_career_success_material_evidence_based"
    t.boolean "edu_career_success_material_add_curr_entirely"
    t.boolean "edu_career_success_material_add_curr_adhoc"
    t.boolean "edu_career_success_material_original_content"
    t.boolean "covered_healthy_life_skills"
    t.boolean "healthy_life_skills_material_evidence_based"
    t.boolean "healthy_life_skills_material_add_curr_entirely"
    t.boolean "healthy_life_skills_material_add_curr_adhoc"
    t.boolean "healthy_life_skills_material_original_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "extra_name"
    t.integer "intended_participants_hs"
    t.integer "intended_participants_ms"
    t.integer "reliable_stat"
    t.integer "drift_stat"
    t.boolean "uses_enrollment", default: false
    t.string "address"
    t.string "facilitator"
    t.index ["provider_id"], name: "index_cohorts_on_provider_id"
  end

  create_table "enrollment_session_logs", force: :cascade do |t|
    t.bigint "enrollment_id", null: false
    t.bigint "session_log_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["enrollment_id"], name: "index_enrollment_session_logs_on_enrollment_id"
    t.index ["session_log_id"], name: "index_enrollment_session_logs_on_session_log_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "cohort_id"
    t.string "name_first"
    t.string "name_pref"
    t.string "name_last"
    t.boolean "needs_perm"
    t.boolean "perm_prog"
    t.boolean "perm_surveys"
    t.boolean "trashed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "graduate", default: false
    t.decimal "age"
    t.boolean "gender_m"
    t.boolean "gender_f"
    t.boolean "gender_o"
    t.boolean "gender_n"
    t.boolean "race_wh"
    t.boolean "race_bl"
    t.boolean "race_in"
    t.boolean "race_as"
    t.boolean "race_hw"
    t.boolean "race_or"
    t.boolean "race_no"
    t.boolean "race_es"
    t.boolean "lgbt"
    t.boolean "preg_par"
    t.index ["cohort_id"], name: "index_enrollments_on_cohort_id"
  end

  create_table "entry_surveys", force: :cascade do |t|
    t.string "magic"
    t.string "contractor"
    t.string "cohort"
    t.string "curriculum"
    t.boolean "lang_sp", default: false
    t.boolean "lang_en", default: false
    t.boolean "lang_other", default: false
    t.string "lang_other_txt"
    t.boolean "race_indian", default: false
    t.boolean "race_asian", default: false
    t.boolean "race_black", default: false
    t.boolean "race_pacific", default: false
    t.boolean "race_white", default: false
    t.boolean "race_other", default: false
    t.string "race_other_txt"
    t.boolean "lives_family", default: false
    t.boolean "lives_foster_family", default: false
    t.boolean "lives_foster_group", default: false
    t.boolean "lives_couch", default: false
    t.boolean "lives_outside", default: false
    t.boolean "lives_shelter", default: false
    t.boolean "lives_hotel", default: false
    t.boolean "lives_jail", default: false
    t.boolean "lives_none", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "h_age", default: 0
    t.integer "h_grade", default: 0
    t.integer "m_age", default: 0
    t.integer "m_grade", default: 0
    t.integer "is_hispanic", default: 0
    t.integer "is_male", default: 0
    t.integer "behavior_peer", default: 0
    t.integer "behavior_emotion", default: 0
    t.integer "behavior_alcohol", default: 0
    t.integer "behavior_think", default: 0
    t.integer "intent_plans", default: 0
    t.integer "intent_study", default: 0
    t.integer "intent_graduate", default: 0
    t.integer "intent_more_study", default: 0
    t.integer "intent_work", default: 0
    t.integer "intent_speakup_self", default: 0
    t.integer "intent_speakup_others", default: 0
    t.integer "finance_save", default: 0
    t.integer "finance_bank", default: 0
    t.integer "finance_budget", default: 0
    t.integer "finance_track", default: 0
    t.integer "finance_cost", default: 0
    t.integer "talk_parent", default: 0
    t.integer "talk_other", default: 0
    t.integer "relate_healthy", default: 0
    t.integer "relate_info", default: 0
    t.integer "relate_resist", default: 0
    t.integer "relate_talk", default: 0
    t.integer "hadsex", default: 0
    t.integer "num_partners", default: 0
    t.integer "condom", default: 0
    t.integer "contraceptive", default: 0
    t.integer "preg", default: 0
    t.integer "sti", default: 0
    t.integer "sexintent_delaysex_hs", default: 0
    t.integer "sexintent_delaysex_college", default: 0
    t.integer "sexintent_delaysex_marry", default: 0
    t.integer "sexintent_delaykid_marry", default: 0
    t.integer "sexintent_delaymarry_work", default: 0
    t.integer "sexintent_delaychild_work", default: 0
    t.integer "screen_grade", default: 0
    t.string "response_id"
    t.date "happened_on"
  end

  create_table "exit_surveys", force: :cascade do |t|
    t.string "magic"
    t.string "contractor"
    t.string "cohort"
    t.string "curriculum"
    t.integer "h_age", default: 0
    t.integer "h_grade", default: 0
    t.integer "m_age", default: 0
    t.integer "m_grade", default: 0
    t.integer "lang", default: 0
    t.string "lang_other_txt"
    t.integer "is_hispanic", default: 0
    t.integer "race", default: 0
    t.string "race_other_txt"
    t.integer "is_male", default: 0
    t.integer "domestic", default: 0
    t.integer "impact_behavior_peer", default: 0
    t.integer "impact_behavior_emotion", default: 0
    t.integer "impact_behavior_alcohol", default: 0
    t.integer "impact_behavior_think", default: 0
    t.integer "impact_intent_plans", default: 0
    t.integer "impact_intent_study", default: 0
    t.integer "impact_intent_graduate", default: 0
    t.integer "impact_intent_more_study", default: 0
    t.integer "impact_intent_work", default: 0
    t.integer "impact_finance_save", default: 0
    t.integer "impact_finance_bank", default: 0
    t.integer "impact_finance_budget", default: 0
    t.integer "impact_finance_track", default: 0
    t.integer "impact_finance_cost", default: 0
    t.integer "impact_talk_parent", default: 0
    t.integer "impact_talk_other", default: 0
    t.integer "impact_relate_healthy", default: 0
    t.integer "impact_relate_resist", default: 0
    t.integer "impact_relate_talk", default: 0
    t.integer "plan_abstainsex", default: 0
    t.integer "abstain_yes_plans", default: 0
    t.integer "abstain_yes_consequences", default: 0
    t.integer "abstain_yes_sti", default: 0
    t.integer "abstain_yes_preg", default: 0
    t.integer "abstain_notyes_havesex", default: 0
    t.integer "abstain_notyes_condom", default: 0
    t.integer "abstain_notyes_contra", default: 0
    t.integer "percep_clear", default: 0
    t.integer "percep_learn", default: 0
    t.integer "percep_ask", default: 0
    t.integer "percep_respect", default: 0
    t.integer "satisfaction_abstain", default: 0
    t.integer "satisfaction_contra", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "lang_en"
    t.boolean "lang_sp"
    t.boolean "lang_other"
    t.boolean "race_indian"
    t.boolean "race_asian"
    t.boolean "race_black"
    t.boolean "race_pacific"
    t.boolean "race_white"
    t.boolean "race_other"
    t.boolean "lives_family"
    t.boolean "lives_foster_family"
    t.boolean "lives_foster_group"
    t.boolean "lives_couch"
    t.boolean "lives_outside"
    t.boolean "lives_shelter"
    t.boolean "lives_hotel"
    t.boolean "lives_jail"
    t.boolean "lives_none"
    t.integer "screen_grade", default: 0
    t.string "response_id"
    t.integer "percep_interest"
    t.date "happened_on"
  end

  create_table "filters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_filters_on_provider_id"
    t.index ["user_id"], name: "index_filters_on_user_id"
  end

  create_table "grantees", force: :cascade do |t|
    t.decimal "period", precision: 5, scale: 1
    t.boolean "covid_interrupt_admin"
    t.boolean "covid_interrupt_service"
    t.integer "total_grantee_award"
    t.integer "allocation_direct_service"
    t.integer "allocation_training"
    t.integer "allocation_evaluation"
    t.integer "allocation_administrative"
    t.integer "staffing_overseeing"
    t.integer "staffing_covid_vacancies_ever"
    t.integer "staffing_covid_vacancies_filled"
    t.integer "staffing_fte_overseeing"
    t.integer "staffing_fte_covid_vacancies_ever"
    t.integer "staffing_fte_covid_vacancies_filled"
    t.boolean "observed_delivery"
    t.boolean "conducted_training"
    t.boolean "provided_tta"
    t.boolean "observers_grantee"
    t.boolean "observers_developer"
    t.boolean "observers_tta_partner"
    t.boolean "observers_eval_partner"
    t.boolean "observers_prog_provider"
    t.boolean "facil_trainers_grantee"
    t.boolean "facil_trainers_developer"
    t.boolean "facil_trainers_tta_partner"
    t.boolean "facil_trainers_eval_partner"
    t.boolean "facil_trainers_prog_provider"
    t.boolean "tta_providers_grantee"
    t.boolean "tta_providers_developer"
    t.boolean "tta_providers_tta_partner"
    t.boolean "tta_providers_eval_partner"
    t.boolean "tta_providers_prog_provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "handouts", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active"
  end

  create_table "incentives", force: :cascade do |t|
    t.string "fingerprint"
    t.decimal "period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "species"
    t.string "variety"
  end

  create_table "module_lookups", force: :cascade do |t|
    t.decimal "period", precision: 5, scale: 1
    t.string "abbreviated_curriculum"
    t.integer "delivery_sequence"
    t.string "basic_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "providers", force: :cascade do |t|
    t.decimal "period", precision: 5, scale: 1
    t.string "pmms_aggregate_name"
    t.integer "award_amount"
    t.integer "nonprep_funding"
    t.integer "staffing_administering"
    t.integer "staffing_administrative_covid_vacancies_ever"
    t.integer "staffing_administrative_covid_vacancies_filled"
    t.integer "staffing_fte_administering"
    t.integer "staffing_fte_administering_covid_vacancies_ever"
    t.integer "staffing_fte_administering_covid_vacancies_filled"
    t.boolean "provider_new"
    t.boolean "provider_served_youth"
    t.integer "facilitators_total"
    t.integer "facilitators_covid_vacancies_ever"
    t.integer "facilitators_covid_vacancies_filled"
    t.integer "facilitators_trained_core_model"
    t.integer "facilitators_observed_just_once"
    t.integer "facilitators_observed_twice_more"
    t.string "challenges_recruiting_youth"
    t.string "challenges_engagement"
    t.string "challenges_attendance"
    t.string "challenges_recruiting_staff"
    t.string "challenges_staff_understanding"
    t.string "challenges_covering_content"
    t.string "challenges_turnover"
    t.string "challenges_negative_peer_interactions"
    t.string "challenges_youth_behavioral"
    t.string "challenges_facilities"
    t.string "challenges_natural_disasters"
    t.string "challenges_stakeholder_support"
    t.string "tta_recruiting_youth"
    t.string "tta_engagement"
    t.string "tta_attendance"
    t.string "tta_recruiting_staff"
    t.string "tta_training_facilitators"
    t.string "tta_retaining_staff"
    t.string "tta_minimize_negative_peer"
    t.string "tta_addressing_behavior"
    t.string "tta_obtaining_support"
    t.string "tta_evaluation"
    t.string "tta_parent_support"
    t.string "tta_other_text"
    t.string "tta_other_rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "long_name"
    t.boolean "using_optpout"
    t.boolean "done", default: false
    t.boolean "is_test", default: false
    t.boolean "can_pool", default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "session_logs", force: :cascade do |t|
    t.decimal "period", precision: 5, scale: 1
    t.string "magic_code"
    t.bigint "cohort_id", null: false
    t.date "happened_on"
    t.integer "minutes_taught"
    t.integer "middleschool_headcount"
    t.integer "highschool_headcount"
    t.integer "newface_ms_headcount"
    t.integer "newface_hs_headcount"
    t.string "facilitator_initial"
    t.string "participantion_proportion"
    t.string "interest_proportion"
    t.string "enough_time"
    t.boolean "taught_everything"
    t.boolean "adapted_anything"
    t.boolean "participant_referal"
    t.string "impl_setting"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "did_entry_survey"
    t.boolean "did_exit_survey"
    t.index ["cohort_id", "happened_on"], name: "index_session_logs_on_cohort_id_and_happened_on", unique: true
    t.index ["cohort_id"], name: "index_session_logs_on_cohort_id"
  end

  create_table "session_modules", force: :cascade do |t|
    t.bigint "session_log_id", null: false
    t.bigint "module_lookup_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["module_lookup_id"], name: "index_session_modules_on_module_lookup_id"
    t.index ["session_log_id"], name: "index_session_modules_on_session_log_id"
  end

  create_table "staff_training_events", force: :cascade do |t|
    t.string "training_name"
    t.date "training_date"
    t.string "training_place"
    t.string "training_trainer"
    t.integer "period"
    t.integer "decimal"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lookup"
  end

  create_table "staff_training_surveys", force: :cascade do |t|
    t.string "affiliation"
    t.integer "quality_interest"
    t.integer "quality_relevance"
    t.integer "quality_will_use"
    t.integer "quality_will_share"
    t.integer "quality_will_recommend"
    t.text "details_good"
    t.text "details_improvement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "staff_training_event_id", null: false
    t.index ["staff_training_event_id"], name: "index_staff_training_surveys_on_staff_training_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "coho_down_attends", "coho_downs"
  add_foreign_key "coho_downs", "cohorts"
  add_foreign_key "coho_ups", "cohorts"
  add_foreign_key "cohorts", "providers"
  add_foreign_key "enrollment_session_logs", "enrollments"
  add_foreign_key "enrollment_session_logs", "session_logs"
  add_foreign_key "filters", "providers"
  add_foreign_key "filters", "users"
  add_foreign_key "session_logs", "cohorts"
  add_foreign_key "session_modules", "module_lookups"
  add_foreign_key "session_modules", "session_logs"
  add_foreign_key "staff_training_surveys", "staff_training_events"
end
