class ProvidersController < ApplicationController
  before_action :set_provider, only: %i[ show edit update destroy ]
  before_action :extra_set_provider, only: %i[ survey_results ]

  # GET /providers or /providers.json
  def index
    authorize Provider, :index?
    @providers = policy_scope(Provider).order(:pmms_aggregate_name, :long_name)
  end

  # GET /providers/1 or /providers/1.json
  def show
    authorize @provider, :retrieve?
  end

  # GET /providers/new
  def new
    authorize Provider, :create?
    @provider = Provider.new
  end

  # GET /providers/1/edit
  def edit
    authorize @provider, :update?
  end
  
  def finalize
    authorize Provider, :finalize?
    if (!current_user.has_role?(:site_admin, :any)) or (Provider.with_role(:site_admin, current_user).length != 1)
      flash[:danger] = 'The finalize helper only works for users with Site Admin access to ONE Provider. Please manually select a provider to edit.'
      redirect_to providers_path
      return
    end
    redirect_to edit_provider_path(Provider.with_role(:site_admin, current_user).pluck(:id))
  end

  # POST /providers or /providers.json
  def create
    authorize Provider, :create?
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: "Provider was successfully created." }
        format.json { render :show, status: :created, location: @provider }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1 or /providers/1.json
  def update
    authorize @provider, :update?
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to providers_path, notice: "Provider was successfully updated." }
        format.json { render :show, status: :ok, location: @provider }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1 or /providers/1.json
  def destroy
    authorize @provider, :destroy?
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_url, notice: "Provider was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def survey_results
    if @provider.nil?
      authorize Provider, :index?
    else
      authorize @provider, :aggregate?
    end
    if params[:start].nil?
      @window_start = "2021-10-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2022-08-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end
    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    if @provider.nil?
    @providers.map{|i| i.entry_survey_ids}
      my_entry = []
      Provider.all.each{|i| my_entry.push(*i.entry_surveys.pluck(:id))}
      my_exit = []
      Provider.all.each{|i| my_exit.push(*i.exit_surveys.pluck(:id))}
      included_entry = EntrySurvey.where("id in (?) and happened_on >= ? AND happened_on <= ?", my_entry, @window_start, @window_stop)
      included_exit = ExitSurvey.where("id in (?) and happened_on >= ? AND happened_on <= ?", my_exit, @window_start, @window_stop)
    else
      included_entry = @provider.entry_surveys.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop)
      included_exit = @provider.exit_surveys.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop)
    end
    
    @results_entry = {
      total_ms: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      total_hs: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).length,
      total_all: included_entry.length,
      
      relate_healthy_not: included_entry.where(relate_healthy: 1).length,
      relate_healthy_somewhat: included_entry.where(relate_healthy: 2).length,
      relate_healthy_very: included_entry.where(relate_healthy: 3).length,
      relate_healthy_missing: included_entry.where(relate_healthy: nil).or(included_entry.where(relate_healthy: 0)).length,
      relate_healthy_totals: included_entry.where.not(relate_healthy: nil).where.not(relate_healthy: 0).length,
      
      relate_resist_not: included_entry.where(relate_resist: 1).length,
      relate_resist_somewhat: included_entry.where(relate_resist: 2).length,
      relate_resist_very: included_entry.where(relate_resist: 3).length,
      relate_resist_missing: included_entry.where(relate_resist: nil).or(included_entry.where(relate_resist: 0)).length,
      relate_resist_totals: included_entry.where.not(relate_resist: nil).where.not(relate_resist: 0).length,
      
      condom_neversex: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 1).length,
      condom_notrecently: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 2).length,
      condom_always: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 3).length,
      condom_mostly: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 4).length,
      condom_sometimes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 5).length,
      condom_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 6).length,
      condom_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: [0, nil]).length,
      condom_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #condom_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      condom_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: [1, 2, 3, 4, 5, 6]).length,
      
      contraceptive_neversex: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 1).length,
      contraceptive_notrecently: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 2).length,
      contraceptive_always: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 3).length,
      contraceptive_mostly: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 4).length,
      contraceptive_sometimes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 5).length,
      contraceptive_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 6).length,
      contraceptive_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: nil)).length,
      contraceptive_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #contraceptive_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      contraceptive_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: [1, 2, 3, 4, 5, 6]).length
    }
    
    @results_exit = {
      total_ms: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      total_hs: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).length,
      total_all: included_exit.length,

      percep_learn_all: included_exit.where(percep_learn: 1).length,
      percep_learn_most: included_exit.where(percep_learn: 2).length,
      percep_learn_some: included_exit.where(percep_learn: 3).length,
      percep_learn_none: included_exit.where(percep_learn: 4).length,
      percep_learn_missing: included_exit.where(percep_learn: 0).or(included_exit.where(percep_learn: nil)).length,
      percep_learn_totals: included_exit.where.not(percep_learn: 0).where.not(percep_learn: nil).length,
      
      impact_relate_healthy_much_more: included_exit.where(impact_relate_healthy: 1).length,
      impact_relate_healthy_some_more: included_exit.where(impact_relate_healthy: 2).length,
      impact_relate_healthy_same: included_exit.where(impact_relate_healthy: 3).length,
      impact_relate_healthy_some_less: included_exit.where(impact_relate_healthy: 4).length,
      impact_relate_healthy_much_less: included_exit.where(impact_relate_healthy: 5).length,
      impact_relate_healthy_missing: included_exit.where(impact_relate_healthy: nil).or(included_exit.where(impact_relate_healthy: 0)).length,
      impact_relate_healthy_totals: included_exit.where.not(impact_relate_healthy: nil).where.not(impact_relate_healthy: 0).length,
      
      impact_relate_resist_much_more: included_exit.where(impact_relate_resist: 1).length,
      impact_relate_resist_some_more: included_exit.where(impact_relate_resist: 2).length,
      impact_relate_resist_same: included_exit.where(impact_relate_resist: 3).length,
      impact_relate_resist_some_less: included_exit.where(impact_relate_resist: 4).length,
      impact_relate_resist_much_less: included_exit.where(impact_relate_resist: 5).length,
      impact_relate_resist_missing: included_exit.where(impact_relate_resist: nil).or(included_exit.where(impact_relate_resist: 0)).length,
      impact_relate_resist_totals: included_exit.where.not(impact_relate_resist: nil).where.not(impact_relate_resist: 0).length,

      percep_ask_all: included_exit.where(percep_ask: 1).length,
      percep_ask_most: included_exit.where(percep_ask: 2).length,
      percep_ask_some: included_exit.where(percep_ask: 3).length,
      percep_ask_none: included_exit.where(percep_ask: 4).length,
      percep_ask_missing: included_exit.where(percep_ask: 0).or(included_exit.where(percep_ask: nil)).length,
      percep_ask_totals: included_exit.where.not(percep_ask: 0).where.not(percep_ask: nil).length,
      
      satisfaction_abstain_very: included_exit.where(satisfaction_abstain: 1).length,
      satisfaction_abstain_somewhat: included_exit.where(satisfaction_abstain: 2).length,
      satisfaction_abstain_little: included_exit.where(satisfaction_abstain: 3).length,
      satisfaction_abstain_notatall: included_exit.where(satisfaction_abstain: 4).length,
      satisfaction_abstain_missing: included_exit.where(satisfaction_abstain: 0).or(included_exit.where(satisfaction_abstain: nil)).length,
      satisfaction_abstain_totals: included_exit.where.not(satisfaction_abstain: 0).where.not(satisfaction_abstain: nil).length,
      

      abstain_notyes_condom_not_applicable: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 1).length,
      abstain_notyes_condom_much_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 2).length,
      abstain_notyes_condom_some_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 3).length,
      abstain_notyes_condom_same: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 4).length,
      abstain_notyes_condom_some_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 5).length,
      abstain_notyes_condom_much_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 6).length,
      abstain_notyes_condom_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 2, 3]).where(abstain_notyes_condom: [0, nil]).length,
      abstain_notyes_condom_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_notyes_condom_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where.not(abstain_notyes_condom: 0).where.not(abstain_notyes_condom: nil).length,
      abstain_notyes_condom_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: [1, 2, 3, 4, 5, 6]).length,
      abstain_notyes_condom_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
      
      abstain_notyes_contra_not_applicable: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 1).length,
      abstain_notyes_contra_much_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 2).length,
      abstain_notyes_contra_some_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 3).length,
      abstain_notyes_contra_same: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 4).length,
      abstain_notyes_contra_some_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 5).length,
      abstain_notyes_contra_much_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 6).length,
      abstain_notyes_contra_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 2, 3]).where(abstain_notyes_contra: [0, nil]).length,
      abstain_notyes_contra_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_notyes_contra_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where.not(abstain_notyes_contra: 0).where.not(abstain_notyes_contra: nil).length,
      abstain_notyes_contra_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: [1, 2, 3, 4, 5, 6]).length,
      abstain_notyes_contra_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
      
      satisfaction_contra_very: included_exit.where(satisfaction_contra: 1).length,
      satisfaction_contra_somewhat: included_exit.where(satisfaction_contra: 2).length,
      satisfaction_contra_little: included_exit.where(satisfaction_contra: 3).length,
      satisfaction_contra_notatall: included_exit.where(satisfaction_contra: 4).length,
      satisfaction_contra_missing: included_exit.where(satisfaction_contra: 0).or(included_exit.where(satisfaction_contra: nil)).length,
      satisfaction_contra_totals: included_exit.where.not(satisfaction_contra: 0).where.not(satisfaction_contra: nil).length
    }
  end
    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end
    
    def extra_set_provider
      if params[:id].to_i == 0
        @providers = Provider.where(is_test: false)
      else
        @provider = Provider.find(params[:id]) 
      end
    end
    # Only allow a list of trusted parameters through.
    def provider_params
      params.require(:provider).permit(:period, :long_name, :done, :is_test, :can_pool, :pmms_aggregate_name, :award_amount, :nonprep_funding, :staffing_administering, :staffing_administrative_covid_vacancies_ever, :staffing_administrative_covid_vacancies_filled, :staffing_fte_administering, :staffing_fte_administering_covid_vacancies_ever, :staffing_fte_administering_covid_vacancies_filled, :provider_new, :provider_served_youth, :facilitators_total, :facilitators_covid_vacancies_ever, :facilitators_covid_vacancies_filled, :facilitators_trained_core_model, :facilitators_observed_just_once, :facilitators_observed_twice_more, :challenges_recruiting_youth, :challenges_engagement, :challenges_attendance, :challenges_recruiting_staff, :challenges_staff_understanding, :challenges_covering_content, :challenges_turnover, :challenges_negative_peer_interactions, :challenges_youth_behavioral, :challenges_facilities, :challenges_natural_disasters, :challenges_stakeholder_support, :tta_recruiting_youth, :tta_engagement, :tta_attendance, :tta_recruiting_staff, :tta_training_facilitators, :tta_retaining_staff, :tta_minimize_negative_peer, :tta_addressing_behavior, :tta_obtaining_support, :tta_evaluation, :tta_parent_support, :tta_other_text, :tta_other_rating, :using_optpout)
    end
end
