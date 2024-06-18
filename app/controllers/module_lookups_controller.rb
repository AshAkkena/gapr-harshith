class ModuleLookupsController < ApplicationController
  before_action :set_module_lookup, only: %i[ show edit update destroy ]

  # GET /module_lookups or /module_lookups.json
  def index
    authorize ModuleLookup, :index?
    @module_lookups = policy_scope(ModuleLookup).order(:period, :abbreviated_curriculum, :delivery_sequence)
  end

  # GET /module_lookups/1 or /module_lookups/1.json
  def show
    authorize @module_lookup, :retrieve?
  end

  # GET /module_lookups/new
  def new
    authorize ModuleLookup, :create?
    @module_lookup = ModuleLookup.new
  end

  # GET /module_lookups/1/edit
  def edit
    authorize @module_lookup, :update?
  end

  # POST /module_lookups or /module_lookups.json
  def create
    authorize ModuleLookup, :create?
    @module_lookup = ModuleLookup.new(module_lookup_params)

    respond_to do |format|
      if @module_lookup.save
        format.html { redirect_to @module_lookup, notice: "Module lookup was successfully created." }
        format.json { render :show, status: :created, location: @module_lookup }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @module_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /module_lookups/1 or /module_lookups/1.json
  def update
    authorize @module_lookup, :update?
    respond_to do |format|
      if @module_lookup.update(module_lookup_params)
        format.html { redirect_to @module_lookup, notice: "Module lookup was successfully updated." }
        format.json { render :show, status: :ok, location: @module_lookup }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @module_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /module_lookups/1 or /module_lookups/1.json
  def destroy
    authorize @module_lookup, :destroy?
    @module_lookup.destroy
    respond_to do |format|
      format.html { redirect_to module_lookups_url, notice: "Module lookup was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_module_lookup
      @module_lookup = ModuleLookup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def module_lookup_params
      params.require(:module_lookup).permit(:period, :abbreviated_curriculum, :delivery_sequence, :basic_name)
    end
end
