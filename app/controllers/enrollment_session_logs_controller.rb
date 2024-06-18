class EnrollmentSessionLogsController < ApplicationController
  before_action :set_enrollment_session_log, only: %i[ show edit update destroy ]

  # GET /enrollment_session_logs or /enrollment_session_logs.json
  def index
    authorize EnrollmentSessionLog, :index?
    @enrollment_session_logs = policy_scope(EnrollmentSessionLog)
  end

  # GET /enrollment_session_logs/1 or /enrollment_session_logs/1.json
  def show
  end

  # GET /enrollment_session_logs/new
  def new
    @enrollment_session_log = EnrollmentSessionLog.new
  end

  # GET /enrollment_session_logs/1/edit
  def edit
  end

  # POST /enrollment_session_logs or /enrollment_session_logs.json
  def create
    @enrollment_session_log = EnrollmentSessionLog.new(enrollment_session_log_params)

    respond_to do |format|
      if @enrollment_session_log.save
        format.html { redirect_to enrollment_session_log_url(@enrollment_session_log), notice: "Enrollment session log was successfully created." }
        format.json { render :show, status: :created, location: @enrollment_session_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment_session_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollment_session_logs/1 or /enrollment_session_logs/1.json
  def update
    respond_to do |format|
      if @enrollment_session_log.update(enrollment_session_log_params)
        format.html { redirect_to enrollment_session_log_url(@enrollment_session_log), notice: "Enrollment session log was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment_session_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment_session_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollment_session_logs/1 or /enrollment_session_logs/1.json
  def destroy
    @enrollment_session_log.destroy

    respond_to do |format|
      format.html { redirect_to enrollment_session_logs_url, notice: "Enrollment session log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment_session_log
      @enrollment_session_log = EnrollmentSessionLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_session_log_params
      params.require(:enrollment_session_log).permit(:enrollment_id, :session_log_id)
    end
end
