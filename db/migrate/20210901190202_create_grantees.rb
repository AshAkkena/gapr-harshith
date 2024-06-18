class CreateGrantees < ActiveRecord::Migration[6.1]
  def change
    create_table :grantees do |t|
      t.integer :period
      t.boolean :covid_interrupt_admin
      t.boolean :covid_interrupt_service
      t.integer :total_grantee_award
      t.integer :allocation_direct_service
      t.integer :allocation_training
      t.integer :allocation_evaluation
      t.integer :allocation_administrative
      t.integer :staffing_overseeing
      t.integer :staffing_covid_vacancies_ever
      t.integer :staffing_covid_vacancies_filled
      t.integer :staffing_fte_overseeing
      t.integer :staffing_fte_covid_vacancies_ever
      t.integer :staffing_fte_covid_vacancies_filled
      t.boolean :observed_delivery
      t.boolean :conducted_training
      t.boolean :provided_tta
      t.boolean :observers_grantee
      t.boolean :observers_developer
      t.boolean :observers_tta_partner
      t.boolean :observers_eval_partner
      t.boolean :observers_prog_provider
      t.boolean :facil_trainers_grantee
      t.boolean :facil_trainers_developer
      t.boolean :facil_trainers_tta_partner
      t.boolean :facil_trainers_eval_partner
      t.boolean :facil_trainers_prog_provider
      t.boolean :tta_providers_grantee
      t.boolean :tta_providers_developer
      t.boolean :tta_providers_tta_partner
      t.boolean :tta_providers_eval_partner
      t.boolean :tta_providers_prog_provider

      t.timestamps
    end
  end
end
