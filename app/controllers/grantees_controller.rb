class GranteesController < ApplicationController
  before_action :set_grantee, only: %i[ show edit update destroy ]
  # GET /grantees or /grantees.json
  def index
    authorize Grantee, :index?
    @grantees = Grantee.all
  end

  # GET /grantees/1 or /grantees/1.json
  def show
    authorize Grantee, :retrieve?
  end

  # GET /grantees/new
  def new
    authorize Grantee, :create?
    @grantee = Grantee.new
  end

  # GET /grantees/1/edit
  def edit
    authorize Grantee, :update?
  end

  # POST /grantees or /grantees.json
  def create
    authorize Grantee, :create?
    @grantee = Grantee.new(grantee_params)

    respond_to do |format|
      if @grantee.save
        format.html { redirect_to @grantee, notice: "Grantee was successfully created." }
        format.json { render :show, status: :created, location: @grantee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grantee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grantees/1 or /grantees/1.json
  def update
    authorize Grantee, :update?
    respond_to do |format|
      if @grantee.update(grantee_params)
        format.html { redirect_to @grantee, notice: "Grantee was successfully updated." }
        format.json { render :show, status: :ok, location: @grantee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grantee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grantees/1 or /grantees/1.json
  def destroy
    authorize Grantee, :destroy?
    @grantee.destroy
    respond_to do |format|
      format.html { redirect_to grantees_url, notice: "Grantee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grantee
      @grantee = Grantee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grantee_params
      params.require(:grantee).permit(:period, :covid_interrupt_admin, :covid_interrupt_service, :total_grantee_award, :allocation_direct_service, :allocation_training, :allocation_evaluation, :allocation_administrative, :staffing_overseeing, :staffing_covid_vacancies_ever, :staffing_covid_vacancies_filled, :staffing_fte_overseeing, :staffing_fte_covid_vacancies_ever, :staffing_fte_covid_vacancies_filled, :observed_delivery, :conducted_training, :provided_tta, :observers_grantee, :observers_developer, :observers_tta_partner, :observers_eval_partner, :observers_prog_provider, :facil_trainers_grantee, :facil_trainers_developer, :facil_trainers_tta_partner, :facil_trainers_eval_partner, :facil_trainers_prog_provider, :tta_providers_grantee, :tta_providers_developer, :tta_providers_tta_partner, :tta_providers_eval_partner, :tta_providers_prog_provider)
    end
end
