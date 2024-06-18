class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy hide prepare_age_patch ]
  before_action :set_cohort, only: %i[ roster ]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # GET /enrollments or /enrollments.json
  def index
    authorize Enrollment, :index?
    
    #@active_cohorts = policy_scope(Cohort).joins(:coho_up).where.missing(:coho_down).where(uses_enrollment: true)
    #@providers = policy_scope(Provider).where(id: @active_cohorts.pluck(:provider_id).uniq)
    #@enrollments = policy_scope(Enrollment).where(cohort_id: @active_cohorts.pluck(:id))
    
    @active_cohorts = Cohort.where(id: policy_scope(Enrollment).pluck(:cohort_id)).joins(:coho_up).where.missing(:coho_down)
    @enrollments = Enrollment.where(cohort_id: @active_cohorts.pluck(:id))
    @providers = Provider.where(id: @active_cohorts.pluck(:provider_id).uniq)
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    authorize Enrollment, :retrieve?
  end

  # GET /enrollments/new
  def new
    authorize Enrollment, :create?
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    authorize Enrollment, :update?
  end

  # POST /enrollments or /enrollments.json
  def create
    authorize Enrollment, :create?
    if request.format.json?
      if request.headers["X-API-TOKEN"] != Rails.application.credentials.dig(:qualtrics, :secret)
        return
      end
      if Rails.env.development?
        params[:enrollment].each { |key, value| puts "in: " + key.to_s + " : " + value.to_s }
      end
      my_params = params[:enrollment]
      if my_params[:magic].nil? 
        my_params[:magic] = params[:magic]
      end
      if my_params[:is_parent].nil? 
        my_params[:is_parent] = params[:is_parent]
      end
      if my_params[:parent_perm_program].nil? 
        my_params[:parent_perm_program] = params[:parent_perm_program]
      end
      if my_params[:parent_perm_program].nil? 
        my_params[:parent_perm_program] = params[:parent_perm_program]
      end
      if my_params[:parent_perm_survey].nil? 
        my_params[:parent_perm_survey] = params[:parent_perm_survey]
      end
      if my_params[:name_first].nil? 
        my_params[:name_first] = params[:name_first]
      end
      if my_params[:name_last].nil? 
        my_params[:name_last] = params[:name_last]
      end
      if my_params[:name_pref].nil? 
        my_params[:name_pref] = params[:name_pref]
      end

      if my_params[:dob].nil? 
        my_params[:dob] = params[:dob]
      end
      if my_params[:gender].nil? 
        my_params[:gender] = params[:gender]
      end
      if my_params[:race].nil? 
        my_params[:race] = params[:race]
      end
      if my_params[:race_es].nil? 
        my_params[:race_es] = params[:race_es]
      end
      if my_params[:lgbt].nil? 
        my_params[:lgbt] = params[:lgbt]
      end
      if my_params[:preg].nil? 
        my_params[:preg] = params[:preg]
      end
      if my_params[:par].nil? 
        my_params[:par] = params[:par]
      end

      my_params[:name_last] = my_params[:name_last][0]

      my_params[:needs_perm] = my_params[:is_parent].to_s["1"] ? true : false
      my_params[:perm_prog] = my_params[:parent_perm_program].to_s["1"] ? true : false
      my_params[:perm_surveys] = my_params[:parent_perm_survey].to_s["1"] ? true : false
      my_params.delete(:is_parent)
      my_params.delete(:parent_perm_program)
      my_params.delete(:parent_perm_survey)
      
      if (CohoUp.where(magic_code: my_params[:magic]).length == 1)
        my_params[:cohort_id] = CohoUp.where(magic_code: my_params[:magic]).first.cohort_id
      else
        my_params[:cohort_id] = nil
      end
      my_params.delete(:magic)
      
      my_params[:age] = (DateTime.current.to_date - Date.parse(my_params[:dob])).to_i / 365
      my_params.delete(:dob)
      
      my_params[:gender] = my_params[:gender].to_s
      my_params[:gender_m] = my_params[:gender]["1"] ? true : false
      my_params[:gender_f] = my_params[:gender]["2"] ? true : false
      my_params[:gender_o] = my_params[:gender]["3"] ? true : false
      my_params[:gender_n] = my_params[:gender]["4"] ? true : false
      my_params.delete(:gender)
      
      
      my_params[:race] = my_params[:race].to_s
      my_params[:race_es] = my_params[:race_es].to_s
      my_params[:race_wh] = my_params[:race]["1"] ? true : false
      my_params[:race_bl] = my_params[:race]["2"] ? true : false
      my_params[:race_in] = my_params[:race]["3"] ? true : false
      my_params[:race_as] = my_params[:race]["4"] ? true : false
      my_params[:race_hw] = my_params[:race]["5"] ? true : false
      my_params[:race_or] = my_params[:race]["6"] ? true : false
      my_params[:race_no] = my_params[:race]["7"] ? true : false
      my_params.delete(:race)
      my_params[:race_es] = my_params[:race_es]["1"] ? true : false

      my_params[:lgbt] = my_params[:lgbt].to_s
      my_params[:lgbt] = my_params[:lgbt]["1"] ? true : false
      my_params.delete(:lgbt)
      
      my_params[:par] = my_params[:par].to_s
      my_params[:preg] = my_params[:preg].to_s
      my_params[:preg_par] = my_params[:par] + my_params[:preg]
      my_params[:preg_par] = my_params[:preg_par]["1"] ? true : false
      my_params.delete(:par)
      my_params.delete(:preg)
      
      my_params.delete(:cohort)
      my_params.delete(:contractor)
      my_params.delete(:curriculum)

      params[:enrollment] = my_params
      if Rails.env.development?
        params[:enrollment].each { |key, value| puts "out: " + key.to_s + " : " + value.to_s }
      end
    end
    
    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to @enrollments, notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollments }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end  
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize Enrollment, :update?
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollments_path, notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollments }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize Enrollment, :destroy?
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def hide
    authorize Enrollment, :destroy?
      if @enrollment.trashed
        @enrollment.trashed = false
      else
        @enrollment.trashed = true
      end
      if @enrollment.save
        flash[:success] = 'Enrollment toggled'
        redirect_to enrollments_path
        return
      else
        flash[:danger] = 'Enrollment not toggled'
        redirect_to enrollments_path
        return
      end
  end
  
  def roster
    authorize Enrollment, :retrieve?
    @curricula_base = ModuleLookup.where(period: Prep::Constants::Year, abbreviated_curriculum: "FLASH").order(:abbreviated_curriculum, :delivery_sequence)
    @curricula_sex = ModuleLookup.where(period: Prep::Constants::Year, abbreviated_curriculum: @cohort.curriculum_choice).order(:abbreviated_curriculum, :delivery_sequence)
    
    @master_roster_table = []
    
    @cohort.enrollments.order(:name_last, :name_first).map{|person| 
      my_response = {}
      my_response = {
        name: person.quick_name,
        age: person.age.to_i,
        sex: person.gender_f ? "F" : person.gender_m ? "M" : "-",
        race_wh: person.race_wh ? "W" : "",
        race_bl: person.race_bl ? "B" : "",
        race_na: person.race_in ? "N" : "",
        race_as: person.race_as ? "A" : "",
        race_pc: person.race_hw ? "P" : "",
        race_oh: person.race_or ? "O" : "",
        race_hs: person.race_es ? "H" : "",
        consent: person.age < 18 ? person.perm_surveys ? "✓" : "✗" : "-",
        base_attendance: @curricula_base.map{|lesson|
                            lesson.session_logs.where(cohort_id: @cohort.id).map{|i| i.enrollments.where(id: person.id).length}.sum > 0 ? "✓" : "✗"
                          },
        sex_attendance: @curricula_sex.map{|lesson|
                            lesson.session_logs.where(cohort_id: @cohort.id).map{|i| i.enrollments.where(id: person.id).length}.sum > 0 ? "✓" : "✗"
                          },
        hours: person.session_logs.pluck(:minutes_taught).sum.to_f / 60
      }
      @master_roster_table.push(my_response)
    }
    @curricula_base_dates = @curricula_base.map{|lesson| lesson.session_logs.where(cohort_id: @cohort.id).pluck(:happened_on)}
    @curricula_sex_dates = @curricula_sex.map{|lesson| lesson.session_logs.where(cohort_id: @cohort.id).pluck(:happened_on)}
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cohort
      if policy_scope(Cohort).find_by_id(params[:cohort_id]).nil?
        flash[:danger] = 'Cohort not found!'
        redirect_to root_url
        return
      else
        @cohort = Cohort.find(params[:cohort_id])
      end
    end
    
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:cohort_id, :name_first, :name_pref, :name_last, :needs_perm, :perm_prog, :perm_surveys, :trashed, :graduate, :age, :gender_m, :gender_f, :gender_o, :gender_n, :race_wh, :race_bl, :race_in, :race_as, :race_hw, :race_or, :race_no, :race_es, :lgbt, :preg_par)
    end
end

