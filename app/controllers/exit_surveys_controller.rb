class ExitSurveysController < ApplicationController
  before_action :set_exit_survey, only: %i[ show edit update destroy recode_one ]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # GET /exit_surveys or /exit_surveys.json
  def index
    authorize ExitSurvey, :index?
    @exit_surveys = policy_scope(ExitSurvey)
  end
  def recode
    authorize ExitSurvey, :index?
    @exit_surveys = policy_scope(ExitSurvey).where(race_other: true).or(policy_scope(ExitSurvey).where(lang_other: true)).order(:happened_on)
  end
  def recode_one
    authorize EntrySurvey, :update?
  end

  # GET /exit_surveys/1 or /exit_surveys/1.json
  def show
    authorize ExitSurvey, :retrieve?
  end

  # GET /exit_surveys/new
  def new
    authorize ExitSurvey, :create?
    @exit_survey = ExitSurvey.new
  end

  # GET /exit_surveys/1/edit
  def edit
    authorize ExitSurvey, :update?
  end

  # POST /exit_surveys or /exit_surveys.json
  def create
    authorize ExitSurvey, :create?
    
    if request.format.json?
      if request.headers["X-API-TOKEN"] != Rails.application.credentials.dig(:qualtrics, :secret)
        return
      end
      if Rails.env.development?
        params[:exit_survey].each { |key, value| puts "in: " + key.to_s + " : " + value.to_s }
      end
      my_params = params[:exit_survey]
      if my_params[:lang].nil? 
        my_params[:lang] = params[:lang]
      end
      if my_params[:race].nil? 
        my_params[:race] = params[:race]
      end
      if my_params[:domestic].nil? 
        my_params[:domestic] = params[:domestic]
      end
      my_params[:lang] = my_params[:lang].to_s
      my_params[:race] = my_params[:race].to_s
      my_params[:domestic] = my_params[:domestic].to_s

      my_params[:lang_en] = my_params[:lang]["1"] ? true : false
      my_params[:lang_sp] = my_params[:lang]["2"] ? true : false
      my_params[:lang_other] = my_params[:lang]["3"] ? true : false
      my_params.delete(:lang)
      
      my_params[:race_indian] = my_params[:race]["1"] ? true : false
      my_params[:race_asian] = my_params[:race]["2"] ? true : false
      my_params[:race_black] = my_params[:race]["3"] ? true : false
      my_params[:race_pacific] = my_params[:race]["4"] ? true : false
      my_params[:race_white] = my_params[:race]["5"] ? true : false
      my_params[:race_other] = my_params[:race]["6"] ? true : false
      my_params.delete(:race)
      
      my_params[:lives_family] = my_params[:domestic]["1"] ? true : false
      my_params[:lives_foster_family] = my_params[:domestic]["2"] ? true : false
      my_params[:lives_foster_group] = my_params[:domestic]["3"] ? true : false
      my_params[:lives_couch] = my_params[:domestic]["4"] ? true : false
      my_params[:lives_outside] = my_params[:domestic]["5"] ? true : false
      my_params[:lives_shelter] = my_params[:domestic]["6"] ? true : false
      my_params[:lives_hotel] = my_params[:domestic]["7"] ? true : false
      my_params[:lives_jail] = my_params[:domestic]["8"] ? true : false
      my_params[:lives_none] = my_params[:domestic]["9"] ? true : false
      my_params.delete(:domestic)
      
      params[:exit_survey] = my_params
      if Rails.env.development?
        params[:exit_survey].each { |key, value| puts "out: " + key.to_s + " : " + value.to_s }
      end
    end
    
    
    @exit_survey = ExitSurvey.new(exit_survey_params)

    respond_to do |format|
      if @exit_survey.save
        format.html { redirect_to @exit_survey, notice: "Exit survey was successfully created." }
        format.json { render :show, status: :created, location: @exit_survey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exit_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exit_surveys/1 or /exit_surveys/1.json
  def update
    authorize ExitSurvey, :update?
    respond_to do |format|
      if @exit_survey.update(exit_survey_params)
        format.html { redirect_to recode_exit_surveys_path, notice: "Exit survey was successfully updated." }
        format.json { render :show, status: :ok, location: @exit_survey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exit_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exit_surveys/1 or /exit_surveys/1.json
  def destroy
    authorize ExitSurvey, :destroy?
    @exit_survey.destroy
    respond_to do |format|
      format.html { redirect_to exit_surveys_url, notice: "Exit survey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exit_survey
      @exit_survey = ExitSurvey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exit_survey_params
      params.require(:exit_survey).permit(:magic, :contractor, :cohort, :curriculum, :screen_grade, :h_age, :h_grade, :m_age, :m_grade, :lang_sp, :lang_en, :lang_other, :lang_other_txt, :is_hispanic, :race_indian, :race_asian, :race_black, :race_pacific, :race_white, :race_other, :race_other_txt, :is_male, :lives_family, :lives_foster_family, :lives_foster_group, :lives_couch, :lives_outside, :lives_shelter, :lives_hotel, :lives_jail, :lives_none, :impact_behavior_peer, :impact_behavior_emotion, :impact_behavior_alcohol, :impact_behavior_think, :impact_intent_plans, :impact_intent_study, :impact_intent_graduate, :impact_intent_more_study, :impact_intent_work, :impact_finance_save, :impact_finance_bank, :impact_finance_budget, :impact_finance_track, :impact_finance_cost, :impact_talk_parent, :impact_talk_other, :impact_relate_healthy, :impact_relate_resist, :impact_relate_talk, :plan_abstainsex, :abstain_yes_plans, :abstain_yes_consequences, :abstain_yes_sti, :abstain_yes_preg, :abstain_notyes_havesex, :abstain_notyes_condom, :abstain_notyes_contra, :percep_interest, :percep_clear, :percep_learn, :percep_ask, :percep_respect, :satisfaction_abstain, :satisfaction_contra, :response_id, :happened_on)
    end
end
