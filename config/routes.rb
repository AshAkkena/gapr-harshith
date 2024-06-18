Rails.application.routes.draw do

  resources :enrollment_session_logs
  resources :enrollments
  get 'cohorts/(:cohort_id)/roster', to: 'enrollments#roster', as: 'master_roster'
  
  get 'entry_surveys/recode', to: 'entry_surveys#recode', as: 'recode_entry_surveys'
  get 'exit_surveys/recode', to: 'exit_surveys#recode', as: 'recode_exit_surveys'
  get 'entry_surveys/recode/(:id)', to: 'entry_surveys#recode_one', as: 'recode_entry_survey'
  get 'exit_surveys/recode/(:id)', to: 'exit_surveys#recode_one', as: 'recode_exit_survey'
  resources :exit_surveys
  resources :entry_surveys
  get 'providers/(:id)/surveys', to: 'providers#survey_results', as: 'provider_surveys'
  
  resources :incentives
  resources :staff_training_surveys, except: [ :new ]
  resources :staff_training_events
  get 'new_staff_survey/(:lookup)', to: 'staff_training_surveys#new', as: 'new_staff_training_survey'
  
  
  devise_for :users, controllers: {
    sessions: 'users/sessions', 
    registrations: 'users/registrations'
  }

  resources :coho_downs do
    member do
      delete :delete_receipt
    end
  end

  resources :handouts do
    member do
      delete :delete_document
    end
  end
  
  resources :coho_down_attends
  
  resources :session_logs do
    member do
      delete :delete_receipt
    end
  end
  resources :coho_ups
  resources :cohorts
  resources :module_lookups
  resources :providers
  resources :grantees
  resources :session_modules
  get '/filters', to: 'filters#index', as: 'filters'
  post 'filters/:provider_id', to: 'filters#add', as: 'add_filter'
  delete 'filters/:id', to: 'filters#remove', as: 'remove_filter'
  
  get '/finalize_annual_data', to: 'providers#finalize', as: 'finalize_provider'

  get '/incentivize/:species/:variety/:fingerprint', to: 'incentives#record_fingerprint', as: 'incentive_fingerprint'

  get 'users/', to: 'users#index'

  post 'users/:id/deactivate', to: 'users#deactivate', as: 'deactivate_user'
  post 'users/:id/activate', to: 'users#activate', as: 'activate_user'

  post 'users/:id/decoordinate', to: 'users#decoordinate', as: 'decoordinate_user'
  post 'users/:id/coordinate', to: 'users#coordinate', as: 'coordinate_user'

  post 'users/:id/devicar', to: 'users#devicar', as: 'devicar_user'
  post 'users/:id/vicar', to: 'users#vicar', as: 'vicar_user'
  
  post 'users/:id/su_off', to: 'users#detechnician', as: 'detechnician_user'
  post 'users/:id/su_on', to: 'users#technician', as: 'technician_user'
  
  post 'users/:id/detestify', to: 'users#detestify', as: 'detestify_user'
  post 'users/:id/testify', to: 'users#testify', as: 'testify_user'

  post 'users/add_admin', to: 'users#add_site_admin_role', as: 'add_site_admin_for_user'
  post 'users/:id/del_admin/:pid', to: 'users#del_site_admin_role', as: 'del_site_admin_for_user'

  post 'users/add_facilitator', to: 'users#add_facilitator_role', as: 'add_facilitator_for_user'
  post 'users/:id/del_facilitator/:pid', to: 'users#del_facilitator_role', as: 'del_facilitator_for_user'

  get 'cohorts/:id/facilitate', to: 'cohorts#facilitate', as: 'facilitate'
  get 'cohorts/:id/survey', to: 'cohorts#survey', as: 'survey'
  get 'cohorts/:id/enroll', to: 'cohorts#enroll', as: 'enroll'

  post 'handouts/:id/deactivate', to: 'handouts#deactivate', as: 'deactivate_handout'
  post 'handouts/:id/activate', to: 'handouts#activate', as: 'activate_handout'

  post 'enrollments/:id/hide', to: 'enrollments#hide', as: 'hide_enrollment'
  
  get 'reports/registration', to: 'reports#user_registrations', as: 'registration_report'
  get 'reports/activity', to: 'reports#recent_changes', as: 'activity_report'
  get 'reports/at-a-glance', to: 'reports#visualize_cohorts', as: 'visualize_cohorts'
  get 'reports/daily-reach', to: 'reports#daily_reach', as: 'daily_reach'
  get 'reports/outcomes/activities', to: 'reports#outcomes_dashboard_activities', as: 'outcomes_dashboard_activities'
  get 'reports/outcomes/outcomes', to: 'reports#outcomes_dashboard_outcomes', as: 'outcomes_dashboard_outcomes'
  get 'reports/outcomes/demographics', to: 'reports#outcomes_dashboard_demographics', as: 'outcomes_dashboard_demographics'
  get 'reports/outcomes/aggregated', to: 'reports#outcomes_dashboard_aggregated', as: 'outcomes_dashboard_aggregated'
  

  
  get 'reports/cir', to: 'reports#mpr_helper', as: 'mpr_helper'
  get 'reports/ppr', to: 'reports#ppr', as: 'ppr'
  #get 'reports/pmms/ard/:pid/:cname', to: 'reports#pmms_ard_program', as: 'pmms_ard_program'
  #get 'reports/pmms/ard/', to: 'reports#pmms_ard_program_index', as: 'pmms_ard_program_index'
  get 'reports/pmms/surveys/:provider_id/:curriculum_initials', to: 'reports#pmms_surveys', as: 'participant_surveys'
  get 'reports/pmms/surveys', to: 'reports#pmms_survey_index', as: 'pmms_survey_index'
  
  get 'reports/ppr/csv/cbo', to: 'reports#ppr_csv_cbo', as: 'get_ppr_csv_cbo'
  get 'reports/ppr/csv/ahyd', to: 'reports#ppr_csv_ahyd', as: 'get_ppr_csv_ahyd'
  

  root 'pages#index'
end
