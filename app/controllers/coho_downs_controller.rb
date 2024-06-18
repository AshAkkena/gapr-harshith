class CohoDownsController < ApplicationController
  before_action :set_coho_down, only: %i[ show edit update destroy ]

  # GET /coho_downs or /coho_downs.json
  def index
    authorize CohoDown, :index?
    @coho_downs = policy_scope(CohoDown)
  end

  # GET /coho_downs/1 or /coho_downs/1.json
  def show
    authorize @coho_down, :retrieve?
  end

  # GET /coho_downs/new
  def new
    authorize CohoDown, :create?
    if params[:cohort_id].present? 
      if Cohort.find_by(id: params[:cohort_id]).present?
        if Cohort.find_by(id: params[:cohort_id]).coho_up.present?
          if Cohort.find_by(id: params[:cohort_id]).coho_down.present?
            flash[:warning] = 'Cohort already closed.'
            redirect_to cohorts_path
            return        
          else
            @my_cohort = Cohort.find_by(id: params[:cohort_id])
            @coho_down = CohoDown.new
            @coho_down[:cohort_id] = @my_cohort[:id]
            if @my_cohort.session_logs.present?
              if @my_cohort.uses_enrollment?
                @my_cohort.session_logs.order(:happened_on).each{ |e| @coho_down.coho_down_attends.build(happened_on: e[:happened_on], middleschool_headcount: e[:middleschool_headcount], newface_ms_headcount: e[:newface_ms_headcount], highschool_headcount: e[:highschool_headcount], newface_hs_headcount: e[:newface_hs_headcount]) }
                @coho_down[:total_initiated_ms] = @my_cohort.youth_initiates.length
                @coho_down[:total_initiated_hs] = @my_cohort.adult_initiates.length
                #@coho_down[:census_foster] = @my_cohort.
                #@coho_down[:census_homeless] = @my_cohort.
                #@coho_down[:census_pregnant_parenting] = @my_cohort.
                #@coho_down[:census_adjudication] = @my_cohort.
                @coho_down[:ppr_count_total] = @my_cohort.initiates.length
                @coho_down[:ppr_count_male] = @my_cohort.enrollments.where(gender_m: true).length
                @coho_down[:ppr_count_female] = @my_cohort.enrollments.where(gender_f: true).length
                @coho_down[:ppr_count_10_13] = @my_cohort.enrollments.where(age: 10 .. 13).length
                @coho_down[:ppr_count_14_19] = @my_cohort.enrollments.where(age: 14 .. 19).length
                @coho_down[:ppr_count_20] = @my_cohort.enrollments.where('age >= 20').length
                @coho_down[:ppr_count_preg_par] = @my_cohort.enrollments.where(preg_par: true).length
                #@coho_down[:ppr_count_juv_jus] = @my_cohort.
                #@coho_down[:ppr_count_foster] = @my_cohort.
                #@coho_down[:ppr_count_runaway] = @my_cohort.
                @coho_down[:ppr_count_lgbt] = @my_cohort.enrollments.where(lgbt: true).length
                #@coho_down[:ppr_count_total = @my_cohort.
              else
                #@my_cohort.session_logs.order(:happened_on).each{ |e| @coho_down.coho_down_attends.build(happened_on: e[:happened_on]) }
                @my_cohort.session_logs.order(:happened_on).each{ |e| @coho_down.coho_down_attends.build(happened_on: e[:happened_on], middleschool_headcount: e[:middleschool_headcount], newface_ms_headcount: e[:newface_ms_headcount], highschool_headcount: e[:highschool_headcount], newface_hs_headcount: e[:newface_hs_headcount]) }
              end
            end
            @enrollments = Enrollment.where(cohort_id: @coho_down[:cohort_id], trashed: false)
          end
        else
          flash[:warning] = 'Cohort not activated. We can only close active cohorts.'
          redirect_to cohorts_path
          return
        end
      else
        flash[:danger] = 'Cohort not found. Please select another cohort for activation.'
        redirect_to cohorts_path
        return
      end
    else
      flash[:danger] = 'Cohort not provided. Please select a cohort for activation.'
      redirect_to cohorts_path
      return
    end
  end

  # GET /coho_downs/1/edit
  def edit
    authorize @coho_down, :update?
  end

  # POST /coho_downs or /coho_downs.json
  def create
    authorize CohoDown, :create?
    @coho_down = CohoDown.new(coho_down_params)
    if @coho_down.save
        flash[:success] = 'Cohort closed.'
        redirect_to cohorts_path
        return
    else
        flash[:danger] = 'Something went wrong. Cohort not closed.'
        @my_cohort = Cohort.find_by(id: @coho_down[:cohort_id])
        @enrollments = Enrollment.where(cohort_id: :cohort_id, trashed: false)
        render :new
        return
    end
  end

  # PATCH/PUT /coho_downs/1 or /coho_downs/1.json
  def update
    authorize @coho_down, :update?
    respond_to do |format|
      if @coho_down.update(coho_down_params)
        format.html { redirect_to cohorts_path, notice: "Coho down was successfully updated." }
        format.json { render :show, status: :ok, location: @coho_down }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coho_down.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coho_downs/1 or /coho_downs/1.json
  def destroy
    authorize @coho_down, :destroy?
    @coho_down.destroy
    flash[:success] = "Closure destroyed."
    redirect_to cohorts_path    
  end
  def delete_receipt
    authorize @coho_down, :update?
    @my_receipt = ActiveStorage::Attachment.find(params[:id])
    #@my_receipt = SessionLog.find(params[:session_log_id]).receipt
    @my_receipt.purge_later
    flash[:success] = 'Receipt removed.'
    redirect_back(fallback_location: request.referer)
    return
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coho_down
      @coho_down = CohoDown.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coho_down_params
      params.require(:coho_down).permit(:cohort_id, :ppr_count_total, :total_graduated_ms, :total_graduated_hs, :total_initiated_ms, :total_initiated_hs, :total_hours_delivered, :program_complete, :census_foster, :census_homeless, :census_pregnant_parenting, :census_adjudication, :main_setting, :covid_virtualization, :receipt, :ppr_count_male, :ppr_count_female, :ppr_count_10_13, :ppr_count_14_19, :ppr_count_20, :ppr_count_preg_par, :ppr_count_juv_jus, :ppr_count_foster, :ppr_count_runaway, :ppr_count_lgbt, :rationale, graduate_ids: [], coho_down_attends_attributes: [:id, :_destroy, :coho_down_id, :happened_on, :middleschool_headcount, :highschool_headcount, :newface_ms_headcount, :newface_hs_headcount])
    end
end
