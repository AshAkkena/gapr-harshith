class CohoUpsController < ApplicationController
  before_action :set_coho_up, only: %i[ show edit update destroy ]

  # GET /coho_ups or /coho_ups.json
  def index
    authorize CohoUp, :index?
    @coho_ups = policy_scope(CohoUp).order(:cohort_id)
  end

  # GET /coho_ups/1 or /coho_ups/1.json
  def show
    authorize @coho_up, :retrieve?
  end

  # GET /coho_ups/new
  def new
    authorize CohoUp, :create?
    if params[:cohort_id].present? 
      if Cohort.find_by(id: params[:cohort_id]).present?
        if Cohort.find_by(id: params[:cohort_id]).coho_up.present?
          flash[:warning] = 'Cohort already activated. Please select another cohort for activation.'
          redirect_to cohorts_path
          return
        else
          @my_cohort = Cohort.find_by(id: params[:cohort_id])
          @coho_up = CohoUp.new
          @coho_up[:cohort_id] = @my_cohort[:id]
        end
      else
        flash[:danger] = 'Cohort not found. Please select another cohort for activation.'
        redirect_to cohorts_path
      end
    else
      flash[:danger] = 'Cohort not provided. Please select a cohort for activation.'
      redirect_to cohorts_path
    end
  end

  # GET /coho_ups/1/edit
  def edit
    authorize @coho_up, :update?
  end

  # POST /coho_ups or /coho_ups.json
  def create
    authorize CohoUp, :create?
    strong_coho_up_params = coho_up_params
    strong_coho_up_params[:magic_code] = Time.now.to_i.to_s + '-' + SecureRandom.uuid
    @cohort = Cohort.find_by(id: strong_coho_up_params[:cohort_id])
    strong_coho_up_params[:link_entry] = Prep::Constants::Entry + Base64.strict_encode64({contractor: @cohort.provider.long_name, cohort: @cohort.name + " (" + @cohort.extra_name + ")", curriculum: @cohort.curriculum_choice, magic: strong_coho_up_params[:magic_code]}.to_json)
    strong_coho_up_params[:link_exit] = Prep::Constants::Exit + Base64.strict_encode64({contractor: @cohort.provider.long_name, cohort: @cohort.name + " (" + @cohort.extra_name + ")", curriculum: @cohort.curriculum_choice, magic: strong_coho_up_params[:magic_code]}.to_json)

    @coho_up = CohoUp.new(strong_coho_up_params)
    if @coho_up.save
        VicarMailer.with(coho_up: @coho_up).cohoup_notify.deliver_later
        flash[:success] = 'Cohort activated!'
        redirect_to cohorts_path
        return
    else
        flash[:danger] = 'Something went wrong. Cohort not activated.'
        @my_cohort = Cohort.find_by(id: @coho_up[:cohort_id])
        render :new
        return
    end
  end

  # PATCH/PUT /coho_ups/1 or /coho_ups/1.json
  def update
    authorize @coho_up, :update?
    if @coho_up.update(coho_up_params)
        flash[:success] = 'Cohort activation updated!'
        redirect_to cohorts_path
        return
    else
        flash[:danger] = 'Something went wrong. Cohort activation was not updated.'
        redirect_to cohorts_path
        return
    end
  end

  # DELETE /coho_ups/1 or /coho_ups/1.json
  def destroy
    authorize @coho_up, :destroy?
    if @coho_up.destroy
        flash[:success] = 'Activaton destroyed.'
        redirect_to cohorts_path
        return
    else
        flash[:danger] = 'Something went wrong. Cohort activation was not destroyed.'
        redirect_to cohorts_path
        return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coho_up
      @coho_up = CohoUp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coho_up_params
      params.require(:coho_up).permit(:cohort_id, :link_entry, :link_exit, :ppr_count_total, :ppr_count_male, :ppr_count_female, :ppr_count_10_13, :ppr_count_14_19, :ppr_count_20, :ppr_count_preg_par, :ppr_count_juv_jus, :ppr_count_foster, :ppr_count_runaway, :ppr_count_lgbt)
    end
end
