class CohoDownAttendsController < ApplicationController
  before_action :set_coho_down_attend, only: %i[ show edit update destroy ]

  # GET /coho_down_attends or /coho_down_attends.json
  def index
    authorize CohoDownAttend, :index?
    @coho_down_attends = policy_scope(CohoDownAttend).joins(:coho_down => :cohort)
    @providers = Provider.where(id: Cohort.where(id: CohoDown.where(id: @coho_down_attends.pluck(:coho_down_id)).pluck(:cohort_id)).pluck(:provider_id)).order(:pmms_aggregate_name, :long_name)
    @cohorts = Cohort.where(id: CohoDown.where(id: @coho_down_attends.pluck(:coho_down_id)).pluck(:cohort_id)).order(:name, :extra_name)
    @coho_downs = CohoDown.where(id: @coho_down_attends.pluck(:coho_down_id))
  end

  # GET /coho_down_attends/1 or /coho_down_attends/1.json
  def show
    authorize @coho_down_attend, :retrieve?
  end

  # GET /coho_down_attends/new
  def new
    authorize CohoDownAttend, :new?
    @coho_down_attend = CohoDownAttend.new
  end

  # GET /coho_down_attends/1/edit
  def edit
    authorize @coho_down_attend, :update?
  end

  # POST /coho_down_attends or /coho_down_attends.json
  def create
    authorize @coho_down_attend, :create?
    @coho_down_attend = CohoDownAttend.new(coho_down_attend_params)

    respond_to do |format|
      if @coho_down_attend.save
        format.html { redirect_to @coho_down_attend, notice: "Coho down attend was successfully created." }
        format.json { render :show, status: :created, location: @coho_down_attend }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coho_down_attend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coho_down_attends/1 or /coho_down_attends/1.json
  def update
    authorize @coho_down_attend, :update?
    respond_to do |format|
      if @coho_down_attend.update(coho_down_attend_params)
        format.html { redirect_to @coho_down_attend, notice: "Coho down attend was successfully updated." }
        format.json { render :show, status: :ok, location: @coho_down_attend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coho_down_attend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coho_down_attends/1 or /coho_down_attends/1.json
  def destroy
    authorize @coho_down_attend, :destroy?
    @coho_down_attend.destroy
    respond_to do |format|
      format.html { redirect_to coho_down_attends_url, notice: "Coho down attend was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coho_down_attend
      @coho_down_attend = CohoDownAttend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coho_down_attend_params
      params.require(:coho_down_attend).permit(:coho_down_id, :happened_on, :middleschool_headcount, :highschool_headcount, :newface_ms_headcount, :newface_hs_headcount)
    end
end
