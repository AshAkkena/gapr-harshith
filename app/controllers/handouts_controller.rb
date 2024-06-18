class HandoutsController < ApplicationController
  before_action :set_handout, only: %i[ show edit update destroy activate deactivate ]

  # GET /handouts or /handouts.json
  def index
    authorize Handout, :retrieve?
    @handouts = policy_scope(Handout)
  end

  # GET /handouts/1 or /handouts/1.json
  def show
    authorize Handout, :retrieve?
  end

  # GET /handouts/new
  def new
    authorize Handout, :create?
    @handout = Handout.new
  end

  # GET /handouts/1/edit
  def edit
    authorize Handout, :update?
  end

  # POST /handouts or /handouts.json
  def create
    authorize Handout, :create?
    @handout = Handout.new(handout_params)

    respond_to do |format|
      if @handout.save
        format.html { redirect_to @handout, notice: "Handout was successfully created." }
        format.json { render :show, status: :created, location: @handout }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @handout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /handouts/1 or /handouts/1.json
  def update
    authorize Handout, :update?
    respond_to do |format|
      if @handout.update(handout_params)
        format.html { redirect_to @handout, notice: "Handout was successfully updated." }
        format.json { render :show, status: :ok, location: @handout }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @handout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /handouts/1 or /handouts/1.json
  def destroy
    authorize Handout, :destroy?
    @handout.destroy
    respond_to do |format|
      format.html { redirect_to handouts_url, notice: "Handout was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def delete_document
    authorize Handout, :update?
    @my_document = ActiveStorage::Attachment.find(params[:id])
    #@my_receipt = SessionLog.find(params[:session_log_id]).receipt
    @my_document.purge_later
    flash[:success] = 'Document removed.'
    redirect_back(fallback_location: request.referer)
  end
  
  
  def activate
    authorize Handout, :update?
      if @handout.active
        flash[:warning] = 'Handout already active.'
        redirect_to handouts_path
        return
      else
        @handout.active = true
        if @handout.save
          flash[:success] = 'Handout activated'
          redirect_to handouts_path
          return
        else
          flash[:danger] = 'Handout not activated'
          redirect_to handouts_path
          return
        end
      end
  end
  def deactivate
    authorize Handout, :update?
      if !@handout.active
        flash[:warning] = 'Handout already inactive.'
        redirect_to handouts_path
        return
      else
        @handout.active = false
        if @handout.save
          flash[:success] = 'Handout deactivated'
          redirect_to handouts_path
          return
        else
          flash[:danger] = 'Handout not deactivated'
          redirect_to handouts_path
          return
        end
      end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_handout
      @handout = Handout.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def handout_params
      params.require(:handout).permit(:title, :description, :active, :document)
    end
end
