class IncentivesController < ApplicationController
  before_action :set_incentive, only: %i[ show edit update destroy ]

  def record_fingerprint
    authorize Incentive, :fingerprint?
    @incentive = Incentive.new
    @incentive[:fingerprint] = params[:fingerprint]
    @incentive[:variety] = params[:variety]
    @incentive[:species] = params[:species]
    @incentive[:period] = Prep::Constants::Year
    if @incentive.save
      send_file Rails.root.join("public", "coolMaskSmile.png"), type: "image/png", disposition: "inline"
    else
      send_file Rails.root.join("public", "coolSmilieOops.png"), type: "image/png", disposition: "inline"
    end
  end

  # GET /incentives or /incentives.json
  def index
    authorize Incentive, :retrieve?
    @incentives = policy_scope(Incentive)
  end

  # GET /incentives/1 or /incentives/1.json
  def show
    authorize Incentive, :retrieve?
  end

  # GET /incentives/new
  def new
    authorize Incentive, :create?
    @incentive = Incentive.new
  end

  # GET /incentives/1/edit
  def edit
    authorize Incentive, :update?
  end

  # POST /incentives or /incentives.json
  def create
    authorize Incentive, :create?
    @incentive = Incentive.new(incentive_params)

    respond_to do |format|
      if @incentive.save
        format.html { redirect_to @incentive, notice: "Incentive was successfully created." }
        format.json { render :show, status: :created, location: @incentive }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incentive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incentives/1 or /incentives/1.json
  def update
    authorize Incentive, :update?
    respond_to do |format|
      if @incentive.update(incentive_params)
        format.html { redirect_to @incentive, notice: "Incentive was successfully updated." }
        format.json { render :show, status: :ok, location: @incentive }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incentive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incentives/1 or /incentives/1.json
  def destroy
    authorize Incentive, :destroy?
    @incentive.destroy
    respond_to do |format|
      format.html { redirect_to incentives_url, notice: "Incentive was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incentive
      @incentive = Incentive.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def incentive_params
      params.require(:incentive).permit(:fingerprint, :period, :species, :variety)
    end
end
