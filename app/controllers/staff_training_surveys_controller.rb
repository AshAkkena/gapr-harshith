class StaffTrainingSurveysController < ApplicationController
  before_action :set_staff_training_survey, only: %i[ show edit update destroy ]

  # GET /staff_training_surveys or /staff_training_surveys.json
  def index
    authorize StaffTrainingSurvey, :retrieve?
    @staff_training_surveys = policy_scope(StaffTrainingSurvey)
  end

  # GET /staff_training_surveys/1 or /staff_training_surveys/1.json
  def show
    authorize StaffTrainingSurvey, :retrieve?
  end

  # GET /staff_training_surveys/new
  def new
    authorize StaffTrainingSurvey, :create?
    if params[:lookup].present?
      if StaffTrainingEvent.find_by(lookup: params[:lookup]).present?
        #@staff_training_survey = StaffTrainingSurvey.new
        #staff_training_survey_params[:lookup] = params[:lookup]
        #staff_training_survey_params[:staff_trianing_event_id] = StaffTrainingEvent.find_by(lookup: params[:lookup]).pluck(:id)
        @staff_training_survey = StaffTrainingSurvey.new
        @staff_training_event = StaffTrainingEvent.find_by(lookup: params[:lookup])
        @staff_training_survey[:staff_training_event_id] = @staff_training_event.id
      else
        flash[:danger] = 'Staff Training not found.'
        redirect_to root_path
      end
    else
      flash[:warning] = 'Staff Training not supplied.'
      redirect_to root_path
    end
  end

  # GET /staff_training_surveys/1/edit
  def edit
    authorize StaffTrainingSurvey, :update?
  end

  # POST /staff_training_surveys or /staff_training_surveys.json
  def create
    authorize StaffTrainingSurvey, :create?
    @staff_training_survey = StaffTrainingSurvey.new(staff_training_survey_params)

    respond_to do |format|
      if @staff_training_survey.save
        format.html { redirect_to @staff_training_survey, notice: "Staff training survey was successfully created." }
        format.json { render :show, status: :created, location: @staff_training_survey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_training_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_training_surveys/1 or /staff_training_surveys/1.json
  def update
    authorize StaffTrainingSurvey, :update?
    respond_to do |format|
      if @staff_training_survey.update(staff_training_survey_params)
        format.html { redirect_to @staff_training_survey, notice: "Staff training survey was successfully updated." }
        format.json { render :show, status: :ok, location: @staff_training_survey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_training_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_training_surveys/1 or /staff_training_surveys/1.json
  def destroy
    authorize StaffTrainingSurvey, :destroy?
    @staff_training_survey.destroy
    respond_to do |format|
      format.html { redirect_to staff_training_surveys_url, notice: "Staff training survey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_training_survey
      @staff_training_survey = StaffTrainingSurvey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def staff_training_survey_params
      params.require(:staff_training_survey).permit(:affiliation, :staff_training_event_id, :quality_interest, :quality_relevance, :quality_will_use, :quality_will_share, :quality_will_recommend, :details_good, :details_improvement)
    end
end
