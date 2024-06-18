class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers do |t|
      t.integer :period
      t.string :pmms_aggregate_name
      t.integer :award_amount
      t.integer :nonprep_funding
      t.integer :staffing_administering
      t.integer :staffing_administrative_covid_vacancies_ever
      t.integer :staffing_administrative_covid_vacancies_filled
      t.integer :staffing_fte_administering
      t.integer :staffing_fte_administering_covid_vacancies_ever
      t.integer :staffing_fte_administering_covid_vacancies_filled
      t.boolean :provider_new
      t.boolean :provider_served_youth
      t.integer :facilitators_total
      t.integer :facilitators_covid_vacancies_ever
      t.integer :facilitators_covid_vacancies_filled
      t.integer :facilitators_trained_core_model
      t.integer :facilitators_observed_just_once
      t.integer :facilitators_observed_twice_more
      t.string :challenges_recruiting_youth
      t.string :challenges_engagement
      t.string :challenges_attendance
      t.string :challenges_recruiting_staff
      t.string :challenges_staff_understanding
      t.string :challenges_covering_content
      t.string :challenges_turnover
      t.string :challenges_negative_peer_interactions
      t.string :challenges_youth_behavioral
      t.string :challenges_facilities
      t.string :challenges_natural_disasters
      t.string :challenges_stakeholder_support
      t.string :tta_recruiting_youth
      t.string :tta_engagement
      t.string :tta_attendance
      t.string :tta_recruiting_staff
      t.string :tta_training_facilitators
      t.string :tta_retaining_staff
      t.string :tta_minimize_negative_peer
      t.string :tta_addressing_behavior
      t.string :tta_obtaining_support
      t.string :tta_evaluation
      t.string :tta_parent_support
      t.string :tta_other_text
      t.string :tta_other_rating

      t.timestamps
    end
  end
end
