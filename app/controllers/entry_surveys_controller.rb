class EntrySurveysController < ApplicationController
  before_action :set_entry_survey, only: %i[ show edit update destroy recode_one ]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # GET /entry_surveys or /entry_surveys.json
  def index
    authorize EntrySurvey, :index?
    @entry_surveys = policy_scope(EntrySurvey)
  end
  
  def recode
    authorize EntrySurvey, :index?
    @entry_surveys = policy_scope(EntrySurvey).where(race_other: true).or(policy_scope(EntrySurvey).where(lang_other: true)).order(:happened_on)
  end
  def recode_one
    authorize EntrySurvey, :update?
  end

  # GET /entry_surveys/1 or /entry_surveys/1.json
  def show
    authorize EntrySurvey, :retrieve?
  end

  # GET /entry_surveys/new
  def new
    authorize EntrySurvey, :create?
    @entry_survey = EntrySurvey.new
  end

  # GET /entry_surveys/1/edit
  def edit
    authorize EntrySurvey, :update?
  end
  
  # POST /entry_surveys or /entry_surveys.json
  def create
    authorize EntrySurvey, :create?
    if request.format.json?
      if request.headers["X-API-TOKEN"] != Rails.application.credentials.dig(:qualtrics, :secret)
        return
      end
      if Rails.env.development?
        params[:entry_survey].each { |key, value| puts "in: " + key.to_s + " : " + value.to_s }
      end
      my_params = params[:entry_survey]
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
      
      my_params[:happened_on] = my_params[:happened_on]
      
      params[:entry_survey] = my_params
      if Rails.env.development?
        params[:entry_survey].each { |key, value| puts "out: " + key.to_s + " : " + value.to_s }
      end
    end
    
    @entry_survey = EntrySurvey.new(entry_survey_params)

    respond_to do |format|
      if @entry_survey.save
        format.html { redirect_to @entry_survey, notice: "Entry survey was successfully created." }
        format.json { render :show, status: :created, location: @entry_survey }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entry_surveys/1 or /entry_surveys/1.json
  def update
    authorize EntrySurvey, :update?
    respond_to do |format|
      if @entry_survey.update(entry_survey_params)
        format.html { redirect_to recode_entry_surveys_path, notice: "Entry survey was successfully updated." }
        format.json { render :show, status: :ok, location: @entry_survey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_surveys/1 or /entry_surveys/1.json
  def destroy
    authorize EntrySurvey, :destroy?
    @entry_survey.destroy
    respond_to do |format|
      format.html { redirect_to entry_surveys_url, notice: "Entry survey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_survey
      @entry_survey = EntrySurvey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_survey_params
      params.require(:entry_survey).permit(:magic, :contractor, :cohort, :curriculum, :screen_grade, :h_age, :h_grade, :m_age, :m_grade, :lang_sp, :lang_en, :lang_other, :lang_other_txt, :is_hispanic, :race_indian, :race_asian, :race_black, :race_pacific, :race_white, :race_other, :race_other_txt, :is_male, :lives_family, :lives_foster_family, :lives_foster_group, :lives_couch, :lives_outside, :lives_shelter, :lives_hotel, :lives_jail, :lives_none, :behavior_peer, :behavior_emotion, :behavior_alcohol, :behavior_think, :intent_plans, :intent_study, :intent_graduate, :intent_more_study, :intent_work, :intent_speakup_self, :intent_speakup_others, :finance_save, :finance_bank, :finance_budget, :finance_track, :finance_cost, :talk_parent, :talk_other, :relate_healthy, :relate_info, :relate_resist, :relate_talk, :hadsex, :num_partners, :condom, :contraceptive, :preg, :sti, :sexintent_delaysex_hs, :sexintent_delaysex_college, :sexintent_delaysex_marry, :sexintent_delaykid_marry, :sexintent_delaymarry_work, :sexintent_delaychild_work, :response_id, :happened_on)
    end
end
