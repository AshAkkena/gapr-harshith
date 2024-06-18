class StaffTrainingEventsController < ApplicationController
  before_action :set_staff_training_event, only: %i[ show edit update destroy ]

  # GET /staff_training_events or /staff_training_events.json
  def index
    authorize StaffTrainingEvent, :retrieve?
    @staff_training_events = policy_scope(StaffTrainingEvent)
  end

  # GET /staff_training_events/1 or /staff_training_events/1.json
  def show
    authorize StaffTrainingEvent, :retrieve?
  end

  # GET /staff_training_events/new
  def new
    authorize StaffTrainingEvent, :create?
    @staff_training_event = StaffTrainingEvent.new
    @staff_training_event[:period] = Prep::Constants::Year
  end

  # GET /staff_training_events/1/edit
  def edit
    authorize StaffTrainingEvent, :update?
  end

  # POST /staff_training_events or /staff_training_events.json
  def create
    authorize StaffTrainingEvent, :create?
    
    
    #@staff_training_event = StaffTrainingEvent.new(staff_training_event_params)
    
    strong_staff_training_event_params = staff_training_event_params
    strong_staff_training_event_params[:lookup] = SecureRandom.uuid
    
    @staff_training_event = StaffTrainingEvent.new(strong_staff_training_event_params)

    respond_to do |format|
      if @staff_training_event.save
        format.html { redirect_to @staff_training_event, notice: "Staff training event was successfully created." }
        format.json { render :show, status: :created, location: @staff_training_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_training_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_training_events/1 or /staff_training_events/1.json
  def update
    authorize StaffTrainingEvent, :update?
    respond_to do |format|
      if @staff_training_event.update(staff_training_event_params)
        format.html { redirect_to @staff_training_event, notice: "Staff training event was successfully updated." }
        format.json { render :show, status: :ok, location: @staff_training_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_training_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_training_events/1 or /staff_training_events/1.json
  def destroy
    authorize StaffTrainingEvent, :destroy?
    @staff_training_event.destroy
    respond_to do |format|
      format.html { redirect_to staff_training_events_url, notice: "Staff training event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_training_event
      @staff_training_event = StaffTrainingEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def staff_training_event_params
      params.require(:staff_training_event).permit(:training_name, :training_date, :training_place, :training_trainer, :period, :lookup)
    end
end
