class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[ show edit update destroy facilitate survey enroll ]

  # GET /cohorts or /cohorts.json
  def index
    authorize Cohort, :retrieve?
    #scoped_cohorts = policy_scope(Cohort)
    scoped_cohorts = policy_scope(Cohort).joins('LEFT OUTER JOIN "providers" ON "cohorts"."provider_id" = "providers"."id"').select("cohorts.*, CAST(providers.pmms_aggregate_name ~ 'AHYD' AS INT) as isAHYD, providers.long_name").order("isAHYD DESC, providers.long_name, cohorts.name, cohorts.extra_name, intended_start")
    @active_cohorts = scoped_cohorts.joins(:coho_up).where.missing(:coho_down).order(:pmms_aggregate_name, :long_name)
    done_cohorts = scoped_cohorts.joins(:coho_up).joins(:coho_down)
    @draft_cohorts = scoped_cohorts.where.missing(:coho_up)
    @finished_cohorts = []
    @closed_cohorts = []
    done_cohorts.each{|i| i.coho_down.program_complete ? @finished_cohorts.push(i) : @closed_cohorts.push(i) }
    @stale_cohorts = scoped_cohorts.where("intended_finish <= ?", 1.week.ago).joins(:coho_up).where.missing(:coho_down)
    #@cohorts = Cohort.all
  end

  # GET /cohorts/1 or /cohorts/1.json
  def show
    authorize @cohort, :retrieve?
  end

  # GET /cohorts/new
  def new
    authorize Cohort, :create?
    @cohort = Cohort.new
    @providers = current_user.has_role?(:technician) ? policy_scope(Provider) : policy_scope(Provider).where(period: Prep::Constants::Year)
  end

  # GET /cohorts/1/edit
  def edit
    authorize @cohort, :update?
    if @cohort.coho_down.present?
      flash[:danger] = 'Cohorts that have been closed cannot be modified.'
      redirect_to cohorts_path
      return
    end
  end

  # POST /cohorts or /cohorts.json
  def create
    authorize Cohort, :create?
    @cohort = Cohort.new(cohort_params)

    if @cohort.save
      flash[:success] = 'Cohort successfully created.'
      redirect_to cohorts_path
    else
      flash[:danger] = 'Cohort could not save.'
      @providers = current_user.has_role?(:technician) ? policy_scope(Provider) : policy_scope(Provider).where(period: Prep::Constants::Year)
      render :new
    end

#    respond_to do |format|
#      if @cohort.save
#        format.html { redirect_to @cohort, notice: "Cohort was successfully created." }
#        format.json { render :show, status: :created, location: @cohort }
#      else
#        format.html { render :new, status: :unprocessable_entity }
#        format.json { render json: @cohort.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # PATCH/PUT /cohorts/1 or /cohorts/1.json
  def update
    authorize @cohort, :update?
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to @cohort, notice: "Cohort was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohorts/1 or /cohorts/1.json
  def destroy
    authorize @cohort, :destroy?
    if @cohort.coho_up.present? || @cohort.coho_down.present?
      flash[:danger] = 'Cohorts that have been (de)activated cannot be deleted.'
      redirect_to cohorts_url
      return
    else
      @cohort.destroy
      respond_to do |format|
        format.html { redirect_to cohorts_url, notice: "Cohort was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end


  def facilitate
    authorize @cohort, :retrieve?
    @active_cohorts = Cohort.joins(:coho_up).where.missing(:coho_down)
  end

  def survey
    authorize @cohort, :retrieve?
  end
  
  def enroll
    authorize @cohort, :retrieve?
    @special_link = Prep::Constants::Enroll + Base64.strict_encode64({contractor: @cohort.provider.long_name, cohort: @cohort.name + " (" + @cohort.extra_name + ")", curriculum: @cohort.curriculum_choice, magic: @cohort.coho_up.magic_code, contacts: (User.with_role(:site_admin, @cohort.provider).pluck(:email) * ", ")}.to_json)
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort
      if Cohort.find_by_id(params[:id]).nil?
        flash[:danger] = 'Cohort not found!'
        redirect_to root_url
        return
      else
        @cohort = Cohort.find(params[:id])
        @providers = policy_scope(Provider)
      end
    end

    # Only allow a list of trusted parameters through.
    def cohort_params
      params.require(:cohort).permit(:address, :facilitator, :period, :provider_id, :name, :extra_name, :curriculum_choice, :intended_start, :intended_finish, :intended_session_count, :intended_session_duration_minute, :intended_setting, :target_foster, :target_homeless_runaway, :target_hiv_aids, :target_pregnant_parenting, :target_latino, :target_african_american, :target_native_american, :target_adjudicated, :target_male, :target_highneed_geo, :target_dropout, :target_mental_health, :target_trafficked, :covered_healthy_relationship, :healthy_relationship_material_evidence_based, :healthy_relationship_material_add_curr_entirely, :healthy_relationship_material_add_curr_adhoc, :healthy_relationship_material_original_content, :covered_adolescent_development, :adolescent_development_material_evidence_based, :adolescent_development_material_add_curr_entirely, :adolescent_development_material_add_curr_adhoc, :adolescent_development_material_original_content, :covered_financial_literacy, :financial_literacy_material_evidence_based, :financial_literacy_material_add_curr_entirely, :financial_literacy_material_add_curr_adhoc, :financial_literacy_material_original_content, :covered_par_child_comm, :par_child_comm_material_evidence_based, :par_child_comm_material_add_curr_entirely, :par_child_comm_material_add_curr_adhoc, :par_child_comm_material_original_content, :covered_edu_career_success, :edu_career_success_material_evidence_based, :edu_career_success_material_add_curr_entirely, :edu_career_success_material_add_curr_adhoc, :edu_career_success_material_original_content, :covered_healthy_life_skills, :healthy_life_skills_material_evidence_based, :healthy_life_skills_material_add_curr_entirely, :healthy_life_skills_material_add_curr_adhoc, :healthy_life_skills_material_original_content, :intended_participants_ms, :intended_participants_hs, :uses_enrollment)
    end
end
