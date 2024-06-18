class SessionLogsController < ApplicationController
  before_action :set_session_log, only: %i[ show edit update destroy ]

  # GET /session_logs or /session_logs.json
  def index
    authorize SessionLog, :index?
    @session_logs = policy_scope(SessionLog)

    
    #@active_cohorts = policy_scope(Cohort).where(id: @session_logs.all.pluck(:cohort_id)).joins(:coho_up).where.missing(:coho_down).order(:name, :extra_name)
    @active_cohorts = policy_scope(Cohort).where(id: @session_logs.pluck(:cohort_id).uniq)
    @providers = policy_scope(Provider).where(id: @active_cohorts.pluck(:provider_id))
  end

  # GET /session_logs/1 or /session_logs/1.json
  def show
    authorize @session_log, :retrieve?
    #@modules = ModuleLookup.all.where(abbreviated_curriculum: "FLASH").or(ModuleLookup.all.where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice]))
  end

  # GET /session_logs/new
  def new
    authorize SessionLog, :create?
    @session_log = SessionLog.new
    if params[:magic_code].present? 
      if CohoUp.find_by(magic_code: params[:magic_code]).present? and CohoUp.find_by(magic_code: params[:magic_code]).cohort.coho_down.nil?
        @session_log[:magic_code] = params[:magic_code]
        @session_log[:cohort_id] = CohoUp.find_by(magic_code: params[:magic_code])[:cohort_id]
        scoped_modules_a = policy_scope(ModuleLookup).order(:period, :abbreviated_curriculum, :delivery_sequence).where("abbreviated_curriculum!=?", "FLASH").where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice])
        scoped_modules_b = policy_scope(ModuleLookup).order(:period, :abbreviated_curriculum, :delivery_sequence).where("abbreviated_curriculum=?", "FLASH")
        CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice] == "LN" ? @modules = scoped_modules_a : @modules = scoped_modules_a + scoped_modules_b
        #@modules = scoped_modules_a + scoped_modules_b
        @cohort = Cohort.find_by_id(CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort_id)
        @enrollments = Enrollment.where(cohort_id: @cohort.id, trashed: false)
        @session_logs = CohoUp.find_by(magic_code: params[:magic_code]).cohort.session_logs.order(:happened_on)
        #GOOD
      else
        flash[:danger] = 'The QR Helper did not point to an active cohort.'
        redirect_to cohorts_path
      end
    else
      flash[:danger] = 'Access Code required for Session Logs.'
      redirect_to cohorts_path
    end

  end

  # GET /session_logs/1/edit
  def edit
    authorize @session_log, :update?
    #@modules = ModuleLookup.all.where(abbreviated_curriculum: "FLASH").or(ModuleLookup.all.where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice]))
  end

  # POST /session_logs or /session_logs.json
  def create
    authorize SessionLog, :create?
    @session_log = SessionLog.new(session_log_params)

    if !verify_recaptcha
      @modules = ModuleLookup.all.where(abbreviated_curriculum: "FLASH").or(ModuleLookup.all.where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice]))
      @cohort = Cohort.find_by_id(CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort_id)
      @enrollments = Enrollment.where(cohort_id: @cohort.id, trashed: false)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      flash.delete :recaptcha_error
      render :new
    else
      if @session_log.save
        flash[:success] = 'Log created!'
        redirect_to new_session_log_path(magic_code: @session_log.magic_code)
      else
        @modules = ModuleLookup.all.where(abbreviated_curriculum: "FLASH").or(ModuleLookup.all.where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice]))
        @cohort = Cohort.find_by_id(CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort_id)
        @enrollments = Enrollment.where(cohort_id: @cohort.id, trashed: false)
        render :new
      end
    end
  end

  # PATCH/PUT /session_logs/1 or /session_logs/1.json
  def update
    authorize @session_log, :update?
    respond_to do |format|
      if @session_log.update(session_log_params)
        format.html { redirect_to @session_log, notice: "Session log was successfully updated." }
        format.json { render :show, status: :ok, location: @session_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @session_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /session_logs/1 or /session_logs/1.json
  def destroy
    authorize @session_log, :destroy?
    @session_log.destroy
    respond_to do |format|
      format.html { redirect_to session_logs_url, notice: "Session log was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def delete_receipt
    @my_receipt = ActiveStorage::Attachment.find(params[:id])
    @session_log = policy_scope(SessionLog).where(id: @my_receipt[:record_id])
    
    authorize @session_log, :update?
    #@my_receipt = SessionLog.find(params[:session_log_id]).receipt
    @my_receipt.purge_later
    flash[:success] = 'Receipt removed.'
    redirect_back(fallback_location: request.referer)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session_log
      @session_log = SessionLog.find(params[:id])
      @modules = ModuleLookup.all.where(abbreviated_curriculum: "FLASH").or(ModuleLookup.all.where("abbreviated_curriculum=?", CohoUp.find_by(magic_code: @session_log[:magic_code]).cohort[:curriculum_choice]))
      @cohort = @session_log.cohort
      @enrollments = @session_log.enrollments
    end

    # Only allow a list of trusted parameters through.
    def session_log_params
      params.require(:session_log).permit(:period, :magic_code, :cohort_id, :happened_on, :minutes_taught, :middleschool_headcount, :highschool_headcount, :newface_ms_headcount, :newface_hs_headcount, :facilitator_initial, :participantion_proportion, :interest_proportion, :enough_time, :taught_everything, :adapted_anything, :participant_referal, :impl_setting, :receipt, :did_entry_survey, :did_exit_survey, module_lookup_ids: [], enrollment_ids: [])
    end
end
