require 'csv'

class ReportsController < ApplicationController
  def user_registrations
    authorize :report, :view?
   
    @active_users =  User.where(active: true).without_role(:state_coordinator).without_role(:technician).with_role(:site_admin, :any).or(
                     User.where(active: true).without_role(:state_coordinator).without_role(:technician).with_role(:facilitator, :any))
                     .uniq

    @ghost_users =  User.where(active: true).without_role(:state_coordinator).without_role(:vicar).without_role(:technician).without_role(:site_admin, :any).without_role(:facilitator, :any)

    @inactive_users = User.where(active: false)
  end
  
  def recent_changes
    authorize :report, :view?
    #recent_changes_A = PaperTrail::Version.order(:created_at).where("created_at >= ? AND CAST(whodunnit AS INT) NOT IN (?)",  Time.current - 1.week, User.with_role(:technician).pluck(:id))
    #recent_changes_B = PaperTrail::Version.order(:created_at).where("CAST(whodunnit AS INT) NOT IN (?)", User.with_role(:technician).pluck(:id)).last(10)
    #@recent_changes = (recent_changes_A + recent_changes_B).uniq
    
    @recent_cohort_changes = PaperTrail::Version.joins('LEFT OUTER JOIN "users" ON CAST("versions"."whodunnit" AS INT) = "users"."id"').order("versions.created_at": :desc).where("versions.item_type = ? AND versions.created_at >= ? AND CAST(versions.whodunnit AS INT) NOT IN (?)",  "Cohort", Time.current - 1.week, User.with_role(:technician).or(User.with_role(:test)).pluck(:id)).select("versions.*, users.email as email")
    @recent_cohort_activations = PaperTrail::Version.joins('LEFT OUTER JOIN "users" ON CAST("versions"."whodunnit" AS INT) = "users"."id"').order("versions.created_at": :desc).where("versions.item_type = ? AND versions.created_at >= ? AND CAST(versions.whodunnit AS INT) NOT IN (?)",  "CohoUp", Time.current - 1.week, User.with_role(:technician).or(User.with_role(:test)).pluck(:id)).select("versions.*, users.email as email")
    @recent_cohort_closures = PaperTrail::Version.joins('LEFT OUTER JOIN "users" ON CAST("versions"."whodunnit" AS INT) = "users"."id"').order("versions.created_at": :desc).where("versions.item_type = ? AND versions.created_at >= ? AND CAST(versions.whodunnit AS INT) NOT IN (?)",  "CohoDown", Time.current - 1.week, User.with_role(:technician).or(User.with_role(:test)).pluck(:id)).select("versions.*, users.email as email")
    @recent_session_logs = PaperTrail::Version.joins('LEFT OUTER JOIN "users" ON CAST("versions"."whodunnit" AS INT) = "users"."id"').order("versions.created_at": :desc).where("versions.item_type = ? AND versions.created_at >= ? AND CAST(versions.whodunnit AS INT) NOT IN (?)",  "SessionLog", Time.current - 1.week, User.with_role(:technician).or(User.with_role(:test)).pluck(:id)).select("versions.*, users.email as email")
    
    @recent_cohorts = Cohort.where("id IN (?)", @recent_cohort_changes.pluck(:item_id))
    @recent_activation_cohorts = CohoUp.where("id IN (?)", @recent_cohort_activations.pluck(:item_id))
    @recent_closure_cohorts = CohoDown.where("id IN (?)", @recent_cohort_closures.pluck(:item_id))
    @recent_session_log_cohorts = SessionLog.where("id IN (?)", @recent_session_logs.pluck(:item_id))
  end
  
  def visualize_cohorts
    authorize :report, :visualize?
    @scoped_cohorts = policy_scope(Cohort).joins(:coho_up).joins('LEFT OUTER JOIN "providers" ON "cohorts"."provider_id" = "providers"."id"').select("cohorts.*, CAST(providers.pmms_aggregate_name ~ 'AHYD' AS INT) as isAHYD, providers.long_name").where("cohorts.name not similar to ? AND providers.long_name not similar to ?", "%[Tt][Ee][Ss][Tt]%", "%[Tt][Ee][Ss][Tt]%").order("isAHYD DESC, providers.long_name, cohorts.name, cohorts.extra_name, intended_start")
  end
  
  def outcomes_dashboard_activities
    #authorize :report, :view?
    authorize :report, :mpr_helper?

    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    window_sessions = SessionLog.where(happened_on: @window_start .. @window_stop)
    window_attends = CohoDownAttend.where(happened_on: @window_start .. @window_stop)
    window_cohort_ids = (window_sessions.pluck(:cohort_id) + window_attends.map{|i| i.cohort.id}.sort.uniq).sort.uniq
    window_provider_ids = Cohort.where(id: window_cohort_ids).pluck(:provider_id).sort.uniq
    window_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop)
    window_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop)
    @included_providers = policy_scope(Provider).where(id: window_provider_ids)
    @included_cohorts = policy_scope(Cohort).where(id: window_cohort_ids)
    @included_entry = EntrySurvey.where(id: @included_cohorts.map{|i| i.entry_surveys.map{|j| j.id} }.flatten.sort.uniq)
    @included_exit = ExitSurvey.where(id: @included_cohorts.map{|i| i.exit_surveys.map{|j| j.id} }.flatten.sort.uniq)
    
    @poolNames = @included_providers.pluck(:pmms_aggregate_name, :period).sort.uniq
    
    
    #@included_cohorts = @included_providers.map{|i| policy_scope(Cohort).where(provider_id: i).where(id: window_cohort_ids)}
    #@included_entry = @included_cohorts.map{|i| i.entry_surveys}
    #@included_exit = @included_cohorts.map{|i| i.exit_surveys}
    
    
    
    #included_cohorts = policy_scope(Cohort).where(id: CohoUp.where(magic_code: included_entry.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq).or(Cohort.where(id: CohoUp.where(magic_code: included_exit.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq))
    #included_providers = policy_scope(Provider).where(id: included_cohorts.pluck(:provider_id).sort.uniq).order(pmms_aggregate_name: :asc, long_name: :asc)
    
  
  end
  def outcomes_dashboard_outcomes
    authorize :report, :view?
    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    window_sessions = SessionLog.where(happened_on: @window_start .. @window_stop)
    window_attends = CohoDownAttend.where(happened_on: @window_start .. @window_stop)
    window_cohort_ids = (window_sessions.pluck(:cohort_id) + window_attends.map{|i| i.cohort.id}.sort.uniq).sort.uniq
    window_provider_ids = Cohort.where(id: window_cohort_ids).pluck(:provider_id).sort.uniq
    window_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop)
    window_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop)
    @included_providers = policy_scope(Provider).where(id: window_provider_ids)
    @included_cohorts = policy_scope(Cohort).where(id: window_cohort_ids)
    @included_entry = EntrySurvey.where(id: @included_cohorts.map{|i| i.entry_surveys.map{|j| j.id} }.flatten.sort.uniq)
    @included_exit = ExitSurvey.where(id: @included_cohorts.map{|i| i.exit_surveys.map{|j| j.id} }.flatten.sort.uniq)
    
    @poolNames = @included_providers.pluck(:pmms_aggregate_name, :period).sort.uniq
    
    
    #@included_cohorts = @included_providers.map{|i| policy_scope(Cohort).where(provider_id: i).where(id: window_cohort_ids)}
    #@included_entry = @included_cohorts.map{|i| i.entry_surveys}
    #@included_exit = @included_cohorts.map{|i| i.exit_surveys}
    
    
    
    #included_cohorts = policy_scope(Cohort).where(id: CohoUp.where(magic_code: included_entry.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq).or(Cohort.where(id: CohoUp.where(magic_code: included_exit.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq))
    #included_providers = policy_scope(Provider).where(id: included_cohorts.pluck(:provider_id).sort.uniq).order(pmms_aggregate_name: :asc, long_name: :asc)
    
  
  end
  def outcomes_dashboard_demographics
    authorize :report, :view?
    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    window_sessions = SessionLog.where(happened_on: @window_start .. @window_stop)
    window_attends = CohoDownAttend.where(happened_on: @window_start .. @window_stop)
    window_cohort_ids = (window_sessions.pluck(:cohort_id) + window_attends.map{|i| i.cohort.id}.sort.uniq).sort.uniq
    window_provider_ids = Cohort.where(id: window_cohort_ids).pluck(:provider_id).sort.uniq
    window_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop)
    window_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop)
    @included_providers = policy_scope(Provider).where(id: window_provider_ids)
    @included_cohorts = policy_scope(Cohort).where(id: window_cohort_ids)
    @included_entry = EntrySurvey.where(id: @included_cohorts.map{|i| i.entry_surveys.map{|j| j.id} }.flatten.sort.uniq)
    @included_exit = ExitSurvey.where(id: @included_cohorts.map{|i| i.exit_surveys.map{|j| j.id} }.flatten.sort.uniq)
    
    @poolNames = @included_providers.pluck(:pmms_aggregate_name, :period).sort.uniq
    
    
    #@included_cohorts = @included_providers.map{|i| policy_scope(Cohort).where(provider_id: i).where(id: window_cohort_ids)}
    #@included_entry = @included_cohorts.map{|i| i.entry_surveys}
    #@included_exit = @included_cohorts.map{|i| i.exit_surveys}
    
    
    
    #included_cohorts = policy_scope(Cohort).where(id: CohoUp.where(magic_code: included_entry.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq).or(Cohort.where(id: CohoUp.where(magic_code: included_exit.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq))
    #included_providers = policy_scope(Provider).where(id: included_cohorts.pluck(:provider_id).sort.uniq).order(pmms_aggregate_name: :asc, long_name: :asc)
    
  
  end
  def outcomes_dashboard_aggregated
    authorize :report, :view?
    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    window_sessions = SessionLog.where(happened_on: @window_start .. @window_stop)
    window_attends = CohoDownAttend.where(happened_on: @window_start .. @window_stop)
    window_cohort_ids = (window_sessions.pluck(:cohort_id) + window_attends.map{|i| i.cohort.id}.sort.uniq).sort.uniq
    window_provider_ids = Cohort.where(id: window_cohort_ids).pluck(:provider_id).sort.uniq
    window_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop)
    window_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop)
    @included_providers = policy_scope(Provider).where(id: window_provider_ids)
    @included_cohorts = policy_scope(Cohort).where(id: window_cohort_ids)
    @included_entry = EntrySurvey.where(id: @included_cohorts.map{|i| i.entry_surveys.map{|j| j.id} }.flatten.sort.uniq)
    @included_exit = ExitSurvey.where(id: @included_cohorts.map{|i| i.exit_surveys.map{|j| j.id} }.flatten.sort.uniq)
    
    @poolNames = @included_providers.pluck(:pmms_aggregate_name, :period).sort.uniq
    
  end
  def ppr
    authorize :report, :view?
    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end
    
    #if params[:start].class == Array
    #  @window_start = params[:start][0]
    #end
    
    #if params[:stop].class == Array
    #  @window_stop = params[:stop][0]
    #end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    scoped_cohorts = policy_scope(Cohort)

    concerned_cohorts = ( SessionLog.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck("cohort_id").sort.uniq +
      CohoDown.where(id: CohoDownAttend.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck(:coho_down_id).sort.uniq).pluck(:cohort_id).sort.uniq
    ).sort.uniq
    
    concerned_providers_cbo = Provider.where("providers.id in (?) and providers.pmms_aggregate_name != 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq
    concerned_providers_ahyd = Provider.where("providers.id in (?) and providers.pmms_aggregate_name = 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq

    concerned_cohorts_cbo = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_cbo).order(:provider_id, :name)
    concerned_cohorts_ahyd = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_ahyd).order(:provider_id, :name)
    
    def get_bigger(everyone, who, what)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          this_cohort.coho_up[what]
        else
          if this_cohort.coho_down[:ppr_count_total] >= this_cohort.coho_up[:ppr_count_total]
            this_cohort.coho_down[what]
          else
            this_cohort.coho_up[what]
          end
        end
      }
      return my_findings.sum
    end
    
    def get_grads(everyone, who)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          0
        else
            this_cohort.coho_down[:total_graduated_ms] + this_cohort.coho_down[:total_graduated_hs]
        end
      }
      return my_findings.sum
    end

    
    @cbo_data = concerned_cohorts_cbo.pluck(:name).uniq.map { |i| {
     n_provider: concerned_cohorts_cbo.where(name: i).first.provider.long_name,
     n_site: i,
     n_unclosed: concerned_cohorts_cbo.where(name: i).where.missing(:coho_down).length > 0 ? true : false,
     n_initiated: get_bigger(concerned_cohorts_cbo, i, "ppr_count_total"),
     n_graduated: get_grads(concerned_cohorts_cbo, i),
     n_male: get_bigger(concerned_cohorts_cbo, i, "ppr_count_male"),
     n_female: get_bigger(concerned_cohorts_cbo, i, "ppr_count_female"),
     n_10: get_bigger(concerned_cohorts_cbo, i, "ppr_count_10_13"),
     n_14: get_bigger(concerned_cohorts_cbo, i, "ppr_count_14_19"),
     n_20: get_bigger(concerned_cohorts_cbo, i, "ppr_count_20"),
     n_preg: get_bigger(concerned_cohorts_cbo, i, "ppr_count_preg_par"),
     n_justice: get_bigger(concerned_cohorts_cbo, i, "ppr_count_juv_jus"),
     n_foster: get_bigger(concerned_cohorts_cbo, i, "ppr_count_foster"),
     n_runaway: get_bigger(concerned_cohorts_cbo, i, "ppr_count_runaway"),
     n_lgbt: get_bigger(concerned_cohorts_cbo, i, "ppr_count_lgbt")
    }}
    
    @ahyd_data = concerned_cohorts_ahyd.pluck(:name).uniq.map { |i| {
     n_provider: concerned_cohorts_ahyd.where(name: i).first.provider.long_name,
     n_site: i,
     n_unclosed: concerned_cohorts_ahyd.where(name: i).where.missing(:coho_down).length > 0 ? true : false,
     n_initiated: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_total"),
     n_graduated: get_grads(concerned_cohorts_ahyd, i),
     n_male: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_male"),
     n_female: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_female"),
     n_10: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_10_13"),
     n_14: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_14_19"),
     n_20: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_20"),
     n_preg: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_preg_par"),
     n_justice: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_juv_jus"),
     n_foster: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_foster"),
     n_runaway: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_runaway"),
     n_lgbt: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_lgbt")
    }}
    
  end
   
  def daily_reach
    authorize :report, :visualize?
    dumb_logs = policy_scope(SessionLog)
    scoped_logs = policy_scope(SessionLog).joins(:cohort).joins('LEFT OUTER JOIN "providers" ON "cohorts"."provider_id" = "providers"."id"').where("cohorts.name not similar to ? AND providers.long_name not similar to ?", "%[Tt][Ee][Ss][Tt]%", "%[Tt][Ee][Ss][Tt]%").order(:happened_on)
    my_dates = scoped_logs.group(:happened_on).sum(:middleschool_headcount).keys
    ms_total = scoped_logs.group(:happened_on).sum(:middleschool_headcount).values
    hs_total = scoped_logs.group(:happened_on).sum(:highschool_headcount).values
    ms_new = scoped_logs.group(:happened_on).sum(:newface_ms_headcount).values
    hs_new = scoped_logs.group(:happened_on).sum(:newface_hs_headcount).values


    @date_counts = Array.new()
    0.step(my_dates.length - 1, 1).to_a.each {|i| @date_counts.push([ my_dates[i], (ms_total[i] + hs_total[i]) ])}
    
    @date_totals = Array.new()
    0.step(my_dates.length - 1, 1).to_a.each {|i| @date_totals.push([ my_dates[i], (ms_new[0 .. i].sum + hs_new[0 .. i].sum) ])}
  end
  
  def pmms_ard_program_index
    authorize :report, :view?
    @report_choices = Array.new()
    my_providers = Provider.where(is_test: false).pluck(:pmms_aggregate_name).uniq.sort
    my_providers.each{ |i| @report_choices.push(
      pid: i,
      cids: Cohort.where(provider_id: Provider.where(pmms_aggregate_name: i).pluck(:id)).pluck(:curriculum_choice).uniq
    ) }
  end
  
  def pmms_ard_program
    authorize :report, :view?

    #params = {controller: "reports", action: "pmms_ard_program", pid: "AHYD", cname: "MPC"}
    included_cohorts = Cohort.where(provider_id: Provider.where(pmms_aggregate_name: params[:pid]).pluck(:id), curriculum_choice: params[:cname]).where("intended_finish < ?", Date.new(2022, 2, 1)).joins(:coho_down)
    
    results = { 
      dosage_one_session: included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum,
      dosage_ms_count: included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i  }.sum,
      dosage_hs_count: included_cohorts.map{ |i| i.coho_down[:total_initiated_hs].to_i  }.sum,
      dosage_during_school: included_cohorts.map{ |i| i.coho_down[:main_setting] == "In School, during school" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_after_school: included_cohorts.map{ |i| i.coho_down[:main_setting] == "In School, after school" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_community: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Community-Based Organization" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_clinic: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Clinic" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_foster_care: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Foster Care Setting" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_detention: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Juvenile Detention Setting" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_residential_facility: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Residential Mental Health Treatment Facility" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_online: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Virtual" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_other: included_cohorts.map{ |i| i.coho_down[:main_setting] == "Other" ? (i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i) : 0  }.sum,
      dosage_75_percent: included_cohorts.map{ |i| i.coho_down[:total_graduated_ms].to_i + i.coho_down[:total_graduated_hs].to_i }.sum,
      reach_foster: (included_cohorts.map{ |i| i.coho_down[:census_foster].to_i }.sum.to_f / (included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum)) >= 0.5 ? true : false,
      reach_homeless: (included_cohorts.map{ |i| i.coho_down[:census_homeless].to_i }.sum.to_f / (included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum)) >= 0.5 ? true : false,
      reach_preg: (included_cohorts.map{ |i| i.coho_down[:census_pregnant_parenting].to_i }.sum.to_f / (included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum)) >= 0.5 ? true : false,
      reach_adjudication: (included_cohorts.map{ |i| i.coho_down[:census_adjudication].to_i }.sum.to_f / (included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum)) >= 0.5 ? true : false,
      reach_lgbt: (included_cohorts.map{ |i| i.coho_down[:ppr_count_lgbt].to_i }.sum.to_f / (included_cohorts.map{ |i| i.coho_down[:total_initiated_ms].to_i + i.coho_down[:total_initiated_hs].to_i }.sum)) >= 0.5 ? true : false,
      reach_none: false,
      hours_delivered: included_cohorts.map{ |i| 
        (i.coho_down.coho_down_attends.length * i.intended_session_duration_minute)/60.to_f
        #i.coho_down[:total_hours_delivered] 
      }
    }
    if !(results[:reach_foster] or results[:reach_homeless] or results[:reach_preg] or results[:reach_adjudication] or results[:reach_lgbt]) 
      results[:reach_none] = true
    end 
    @data = results
  end
  def pmms_survey_index
    authorize :report, :view?
    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    included_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop)
    included_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop)
    
    included_cohorts = policy_scope(Cohort).where(id: CohoUp.where(magic_code: included_entry.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq).or(Cohort.where(id: CohoUp.where(magic_code: included_exit.pluck(:magic).sort.uniq).pluck(:cohort_id).sort.uniq))
    included_providers = policy_scope(Provider).where(id: included_cohorts.pluck(:provider_id).sort.uniq)
    
    @index_table = included_providers.distinct.pluck(:pmms_aggregate_name).sort.uniq.map{|pool| 
      { pool: pool, 
        pid: included_providers.where(pmms_aggregate_name: pool).pluck(:id).first,
        countMAD: included_cohorts.where(curriculum_choice: "MAD").where(provider_id: included_providers.where(pmms_aggregate_name: pool).pluck(:id)).length,
        countMPC: included_cohorts.where(curriculum_choice: "MPC").where(provider_id: included_providers.where(pmms_aggregate_name: pool).pluck(:id)).length,
        countBPBRBP: included_cohorts.where(curriculum_choice: "BPBRBP").where(provider_id: included_providers.where(pmms_aggregate_name: pool).pluck(:id)).length,
        countLN: included_cohorts.where(curriculum_choice: "LN").where(provider_id: included_providers.where(pmms_aggregate_name: pool).pluck(:id)).length }
      }
  
  end
  def pmms_surveys
      authorize :report, :view?

    if params[:start].nil?
      @window_start = "2023-01-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2023-06-30"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    
    if params[:provider_id].to_i != 0
      if !policy_scope(Provider).pluck(:id).include?(params[:provider_id].to_i)
        flash[:danger] = 'Invalid Provider ID'
        redirect_to root_url
        return
      end
    end
    
    if !["MPC", "MAD", "BPBRBP", "LN", "ALL"].include?(params[:curriculum_initials])
      flash[:danger] = 'Invalid Curriculum. Options include: MPC, MAD, BPBRBP, LN, ALL'
      redirect_to root_url
      return
    end
    
    if params[:provider_id].to_i != 0
      @my_provider = policy_scope(Provider).find_by_id(params[:provider_id].to_i)
      included_providers = policy_scope(Provider).where(pmms_aggregate_name: @my_provider[:pmms_aggregate_name])
    else
      @my_provider = policy_scope(Provider).all
      included_providers = policy_scope(Provider).all
    end
    
    
    if params[:curriculum_initials] == "ALL"
      included_cohorts = policy_scope(Cohort).where(
          id: (SessionLog.where(happened_on: @window_start .. @window_stop).pluck(:cohort_id).sort.uniq +
               CohoDown.where(id: CohoDownAttend.where(happened_on: @window_start .. @window_stop).pluck(:coho_down_id).uniq).pluck(:cohort_id).sort.uniq).sort.uniq, 
          provider_id: included_providers
        )
    else
      included_cohorts = policy_scope(Cohort).where(
        id: (SessionLog.where(happened_on: @window_start .. @window_stop).pluck(:cohort_id).sort.uniq +
             CohoDown.where(id: CohoDownAttend.where(happened_on: @window_start .. @window_stop).pluck(:coho_down_id).uniq).pluck(:cohort_id).sort.uniq).sort.uniq, 
        curriculum_choice: params[:curriculum_initials], 
        provider_id: included_providers
      )
    end
    @included_cohorts = included_cohorts
    
    @check_begin = SessionLog.where(cohort_id: @included_cohorts.pluck(:id)).where(happened_on: @window_start .. @window_stop).map{|i| i[:newface_ms_headcount] + i[:newface_ms_headcount]}.sum > 0
    @check_complete =  @included_cohorts.joins(:coho_down).map{|i| i.latest_date >= @window_start && i.latest_date <= @window_stop ? ((i.coho_down[:total_graduated_ms] + i.coho_down[:total_graduated_hs]) > 0 ? true : false) : false }.any?

    @counts_initiate_all = @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum +
@included_cohorts.where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum
 
    @counts_initiate_ms = @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms]}.sum +
@included_cohorts.where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum}.sum

    @counts_initiate_hs = @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:total_initiated_hs]}.sum +
@included_cohorts.where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_hs_headcount).sum }.sum

    @program_settings = [
      @included_cohorts.where(intended_setting: "In School, during school").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "In School, during school").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "In School, after school").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "In School, after school").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Community-Based Organization").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Community-Based Organization").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Clinic").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Clinic").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Foster Care Setting").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Foster Care Setting").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Juvenile Detention Setting").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Juvenile Detention Setting").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Residential Mental Health Treatment Facility").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Residential Mental Health Treatment Facility").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Virtual").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Virtual").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum,
      @included_cohorts.where(intended_setting: "Other").joins(:coho_down).map{|i| i.coho_down[:total_initiated_ms] + i.coho_down[:total_initiated_hs]}.sum + @included_cohorts.where(intended_setting: "Other").where.missing(:coho_down).map{|i| i.session_logs.pluck(:newface_ms_headcount).sum + i.session_logs.pluck(:newface_hs_headcount).sum }.sum
    ]

    @program_reach = {
      foster: @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_foster]}.sum > (@included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_total]}.sum/2),
      homeless: @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_runaway]}.sum > (@included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_total]}.sum/2),
      pregnant: @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_preg_par]}.sum > (@included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_total]}.sum/2),
      lgbt: @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_lgbt]}.sum > (@included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_total]}.sum/2),
      adjudication: @included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_juv_jus]}.sum > (@included_cohorts.joins(:coho_down).map{|i| i.coho_down[:ppr_count_total]}.sum/2)
    }
    @program_reach[:none] = @program_reach.map{|k, v| v}.none?

    included_entry = EntrySurvey.where(happened_on: @window_start .. @window_stop).where(magic: included_cohorts.map{|i| i.coho_up.present? ? i.coho_up[:magic_code] : ""}.sort.uniq.compact_blank)
    included_exit = ExitSurvey.where(happened_on: @window_start .. @window_stop).where(magic: included_cohorts.map{|i| i.coho_up.present? ? i.coho_up[:magic_code] : ""}.sort.uniq.compact_blank)
    
    @results_entry = {
      total_ms: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      total_hs: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).length,
      total_all: included_entry.length,
      age_10: included_entry.where(m_age: 1).length + included_entry.where(h_age: 1).length,
      age_11: included_entry.where(m_age: 2).length + included_entry.where(h_age: 2).length,
      age_12: included_entry.where(m_age: 3).length + included_entry.where(h_age: 3).length,
      age_13: included_entry.where(m_age: 4).length + included_entry.where(h_age: 4).length,
      age_14: included_entry.where(m_age: 5).length + included_entry.where(h_age: 5).length,
      age_15: included_entry.where(m_age: 6).length + included_entry.where(h_age: 6).length,
      age_16: included_entry.where(m_age: 7).length + included_entry.where(h_age: 7).length,
      age_17: included_entry.where(h_age: 8).length,
      age_18: included_entry.where(h_age: 9).length,
      age_19: included_entry.where(h_age: 10).length,
      age_20: included_entry.where(h_age: 11).length,
      age_21: included_entry.where(h_age: 12).length,
      age_responses: included_entry.where.not(m_age: nil).or(included_entry.where.not(h_age: nil)).length,
      age_missing: included_entry.where(m_age: nil).where(h_age: nil).length,
      grade_5:            included_entry.where(m_grade: 1).length,
      grade_6:            included_entry.where(m_grade: 2).length,
      grade_7:            included_entry.where(m_grade: 3).length,
      grade_8:            included_entry.where(m_grade: 4).length,
      grade_9:            included_entry.where(m_grade: 5).length + included_entry.where(h_grade: 1).length,
      grade_10:                                                    included_entry.where(h_grade: 2).length,
      grade_11:                                                    included_entry.where(h_grade: 3).length,
      grade_12:                                                    included_entry.where(h_grade: 4).length,
      grade_ungraded:     included_entry.where(m_grade: 6).length + included_entry.where(h_grade: 5).length,
      grade_dropout:                                               included_entry.where(h_grade: 6).length,
      grade_getting_ged:                                           included_entry.where(h_grade: 7).length,
      grade_grad_nosec:                                            included_entry.where(h_grade: 8).length,
      grade_grad_sec:                                              included_entry.where(h_grade: 9).length,
      grade_not_in:       included_entry.where(m_grade: 7).length,
      grade_total:        included_entry.where.not(m_grade: [0, nil]).or(included_entry.where.not(h_grade: [0, nil])).length,
      grade_missing:      included_entry.where(m_grade: [0, nil]).where(h_grade: [0, nil]).length,
      lang_en: included_entry.where(lang_en: true).length,
      lang_sp: included_entry.where(lang_sp: true).length,
      lang_other: included_entry.where(lang_other: true).length,
      lang_other_txt: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count,
      lang_other_1: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 1 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[0] : [ "N/A" , 0 ],
      lang_other_2: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 2 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[1] : [ "N/A" , 0 ],
      lang_other_3: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 3 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[2] : [ "N/A" , 0 ],
      lang_other_4: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 4 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[3] : [ "N/A" , 0 ],
      lang_other_5: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 5 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[4] : [ "N/A" , 0 ],
      lang_other_6: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 6 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[5] : [ "N/A" , 0 ],
      lang_other_7: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 7 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[6] : [ "N/A" , 0 ],
      lang_other_8: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 8 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[7] : [ "N/A" , 0 ],
      lang_other_9: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 9 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[8] : [ "N/A" , 0 ],
      lang_other_10: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 10 ? included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[9] : [ "N/A" , 0 ],
      lang_other_extra: included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.length > 10 ? 
                        included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.sum - included_entry.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.first(10).sum : 
                        0,
      lang_other_totals: included_entry.where(lang_other: true).length,
      lang_total: included_entry.where(lang_en: true).or(included_entry.where(lang_sp: true)).or(included_entry.where(lang_other: true)).length,
      lang_missing: included_entry.where.not(lang_en: true).where.not(lang_sp: true).where.not(lang_other: true).length,
      ethnicity_sp: included_entry.where(is_hispanic: 1).length,
      ethnicity_not_sp: included_entry.where(is_hispanic: 2).length,
      ethnicity_total: included_entry.where.not(is_hispanic: nil).where.not(is_hispanic: 0).length,
      ethnicity_missing: included_entry.where(is_hispanic: nil).or(included_entry.where(is_hispanic: 0)).length,
      race_indian: included_entry.where(race_indian: true).length,
      race_asian: included_entry.where(race_asian: true).length,
      race_black: included_entry.where(race_black: true).length,
      race_pacific: included_entry.where(race_pacific: true).length,
      race_white: included_entry.where(race_white: true).length,
      race_other: included_entry.where(race_other: true).length,
      race_other_txt: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count,
      race_other_1: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 1 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[0] : [ "N/A" , 0 ],
      race_other_2: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 2 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[1] : [ "N/A" , 0 ],
      race_other_3: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 3 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[2] : [ "N/A" , 0 ],
      race_other_4: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 4 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[3] : [ "N/A" , 0 ],
      race_other_5: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 5 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[4] : [ "N/A" , 0 ],
      race_other_6: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 6 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[5] : [ "N/A" , 0 ],
      race_other_7: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 7 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[6] : [ "N/A" , 0 ],
      race_other_8: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 8 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[7] : [ "N/A" , 0 ],
      race_other_9: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 9 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[8] : [ "N/A" , 0 ],
      race_other_10: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 10 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[9] : [ "N/A" , 0 ],
      race_other_extra: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.length > 10 ? 
                        included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.sum - included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.first(10).sum : 
                        0,
      race_other_totals: included_entry.where(race_other: true).length,
      race_totals: included_entry.where(race_indian: true).or(
                   included_entry.where(race_asian: true)).or(
                   included_entry.where(race_black: true)).or(
                   included_entry.where(race_pacific: true)).or(
                   included_entry.where(race_white: true)).or(
                   included_entry.where(race_other: true)).length,
      race_missing: included_entry.where.not(race_indian: true)
                                  .where.not(race_asian: true)
                                  .where.not(race_black: true)
                                  .where.not(race_pacific: true)
                                  .where.not(race_white: true)
                                  .where.not(race_other: true).length,
      gender_m: included_entry.where(is_male: 1).length,
      gender_f: included_entry.where(is_male: 2).length,
      gender_totals: included_entry.where(is_male: 1).or(included_entry.where(is_male: 2)).length,
      gender_missing: included_entry.where(is_male: nil).or(included_entry.where(is_male: 0)).length,
      lives_family: included_entry.where(lives_family: true).length,
      lives_foster_family: included_entry.where(lives_foster_family: true).length,
      lives_foster_group: included_entry.where(lives_foster_group: true).length,
      lives_couch: included_entry.where(lives_couch: true).length,
      lives_outside: included_entry.where(lives_outside: true).length,
      lives_shelter: included_entry.where(lives_shelter: true).length,
      lives_hotel: included_entry.where(lives_hotel: true).length,
      lives_jail: included_entry.where(lives_jail: true).length,
      lives_none: included_entry.where(lives_none: true).length,
      lives_totals_family: included_entry.where(lives_family: true).length,
      lives_totals_foster: included_entry.where(lives_foster_family: true).or(included_entry.where(lives_foster_group: true)).length,
      lives_totals_homeless: included_entry.where(lives_couch: true).or(included_entry.where(lives_outside: true)).or(included_entry.where(lives_shelter: true)).or(included_entry.where(lives_hotel: true)).length,
      lives_totals_adjudicaton: included_entry.where(lives_jail: true).length,
      lives_totals_any: included_entry.where(lives_family: true)
                        .or(included_entry.where(lives_family: true))
                        .or(included_entry.where(lives_foster_family: true))
                        .or(included_entry.where(lives_foster_group: true))
                        .or(included_entry.where(lives_couch: true))
                        .or(included_entry.where(lives_outside: true))
                        .or(included_entry.where(lives_shelter: true))
                        .or(included_entry.where(lives_hotel: true))
                        .or(included_entry.where(lives_jail: true))
                        .length,
      lives_totals_missing: included_entry.where.not(lives_family: true)
                        .where.not(lives_family: true)
                        .where.not(lives_foster_family: true)
                        .where.not(lives_foster_group: true)
                        .where.not(lives_couch: true)
                        .where.not(lives_outside: true)
                        .where.not(lives_shelter: true)
                        .where.not(lives_hotel: true)
                        .where.not(lives_jail: true)
                        .length,
      behavior_peer_all: included_entry.where(behavior_peer: 1).length,
      behavior_peer_most: included_entry.where(behavior_peer: 2).length,
      behavior_peer_some: included_entry.where(behavior_peer: 3).length,
      behavior_peer_none: included_entry.where(behavior_peer: 4).length,
      behavior_peer_missing: included_entry.where(behavior_peer: nil).or(included_entry.where(behavior_peer: 0)).length,
      behavior_peer_totals: included_entry.where.not(behavior_peer: nil).where.not(behavior_peer: 0).length,
      
      behavior_emotion_all: included_entry.where(behavior_emotion: 1).length,
      behavior_emotion_most: included_entry.where(behavior_emotion: 2).length,
      behavior_emotion_some: included_entry.where(behavior_emotion: 3).length,
      behavior_emotion_none: included_entry.where(behavior_emotion: 4).length,
      behavior_emotion_missing: included_entry.where(behavior_emotion: nil).or(included_entry.where(behavior_emotion: 0)).length,
      behavior_emotion_totals: included_entry.where.not(behavior_emotion: nil).where.not(behavior_emotion: 0).length,
    
      behavior_alcohol_all: included_entry.where(behavior_alcohol: 1).length,
      behavior_alcohol_most: included_entry.where(behavior_alcohol: 2).length,
      behavior_alcohol_some: included_entry.where(behavior_alcohol: 3).length,
      behavior_alcohol_none: included_entry.where(behavior_alcohol: 4).length,
      behavior_alcohol_missing: included_entry.where(behavior_alcohol: nil).or(included_entry.where(behavior_alcohol: 0)).length,
      behavior_alcohol_totals: included_entry.where.not(behavior_alcohol: nil).where.not(behavior_alcohol: 0).length,
      
      behavior_think_all: included_entry.where(behavior_think: 1).length,
      behavior_think_most: included_entry.where(behavior_think: 2).length,
      behavior_think_some: included_entry.where(behavior_think: 3).length,
      behavior_think_none: included_entry.where(behavior_think: 4).length,
      behavior_think_missing: included_entry.where(behavior_think: nil).or(included_entry.where(behavior_think: 0)).length,
      behavior_think_totals: included_entry.where.not(behavior_think: nil).where.not(behavior_think: 0).length,
      
      intent_plans_not: included_entry.where(intent_plans: 1).length,
      intent_plans_somewhat: included_entry.where(intent_plans: 2).length,
      intent_plans_very: included_entry.where(intent_plans: 3).length,
      intent_plans_missing: included_entry.where(intent_plans: nil).or(included_entry.where(intent_plans: 0)).length,
      intent_plans_totals: included_entry.where.not(intent_plans: nil).where.not(intent_plans: 0).length,
      
      intent_study_not: included_entry.where(intent_study: 1).length,
      intent_study_somewhat: included_entry.where(intent_study: 2).length,
      intent_study_very: included_entry.where(intent_study: 3).length,
      intent_study_missing: included_entry.where(intent_study: nil).or(included_entry.where(intent_study: 0)).length,
      intent_study_totals: included_entry.where.not(intent_study: nil).where.not(intent_study: 0).length,
      
      intent_graduate_not: included_entry.where(intent_graduate: 1).length,
      intent_graduate_somewhat: included_entry.where(intent_graduate: 2).length,
      intent_graduate_very: included_entry.where(intent_graduate: 3).length,
      intent_graduate_missing: included_entry.where(intent_graduate: nil).or(included_entry.where(intent_graduate: 0)).length,
      intent_graduate_totals: included_entry.where.not(intent_graduate: nil).where.not(intent_graduate: 0).length,
      
      intent_more_study_not: included_entry.where(intent_more_study: 1).length,
      intent_more_study_somewhat: included_entry.where(intent_more_study: 2).length,
      intent_more_study_very: included_entry.where(intent_more_study: 3).length,
      intent_more_study_missing: included_entry.where(intent_more_study: nil).or(included_entry.where(intent_more_study: 0)).length,
      intent_more_study_totals: included_entry.where.not(intent_more_study: nil).where.not(intent_more_study: 0).length,
      
      intent_work_not: included_entry.where(intent_work: 1).length,
      intent_work_somewhat: included_entry.where(intent_work: 2).length,
      intent_work_very: included_entry.where(intent_work: 3).length,
      intent_work_missing: included_entry.where(intent_work: nil).or(included_entry.where(intent_work: 0)).length,
      intent_work_totals: included_entry.where.not(intent_work: nil).where.not(intent_work: 0).length,
      
      intent_speakup_self_not: included_entry.where(intent_speakup_self: 1).length,
      intent_speakup_self_somewhat: included_entry.where(intent_speakup_self: 2).length,
      intent_speakup_self_very: included_entry.where(intent_speakup_self: 3).length,
      intent_speakup_self_missing: included_entry.where(intent_speakup_self: nil).or(included_entry.where(intent_speakup_self: 0)).length,
      intent_speakup_self_totals: included_entry.where.not(intent_speakup_self: nil).where.not(intent_speakup_self: 0).length,
      
      intent_speakup_others_not: included_entry.where(intent_speakup_others: 1).length,
      intent_speakup_others_somewhat: included_entry.where(intent_speakup_others: 2).length,
      intent_speakup_others_very: included_entry.where(intent_speakup_others: 3).length,
      intent_speakup_others_missing: included_entry.where(intent_speakup_others: nil).or(included_entry.where(intent_speakup_others: 0)).length,
      intent_speakup_others_totals: included_entry.where.not(intent_speakup_others: nil).where.not(intent_speakup_others: 0).length,
      
      finance_save_not: included_entry.where(finance_save: 1).length,
      finance_save_somewhat: included_entry.where(finance_save: 2).length,
      finance_save_very: included_entry.where(finance_save: 3).length,
      finance_save_missing: included_entry.where(finance_save: nil).or(included_entry.where(finance_save: 0)).length,
      finance_save_totals: included_entry.where.not(finance_save: nil).where.not(finance_save: 0).length,
      
      finance_bank_not: included_entry.where(finance_bank: 1).length,
      finance_bank_somewhat: included_entry.where(finance_bank: 2).length,
      finance_bank_very: included_entry.where(finance_bank: 3).length,
      finance_bank_missing: included_entry.where(finance_bank: nil).or(included_entry.where(finance_bank: 0)).length,
      finance_bank_totals: included_entry.where.not(finance_bank: nil).where.not(finance_bank: 0).length,
      
      finance_budget_not: included_entry.where(finance_budget: 1).length,
      finance_budget_somewhat: included_entry.where(finance_budget: 2).length,
      finance_budget_very: included_entry.where(finance_budget: 3).length,
      finance_budget_missing: included_entry.where(finance_budget: nil).or(included_entry.where(finance_budget: 0)).length,
      finance_budget_totals: included_entry.where.not(finance_budget: nil).where.not(finance_budget: 0).length,
      
      finance_track_not: included_entry.where(finance_track: 1).length,
      finance_track_somewhat: included_entry.where(finance_track: 2).length,
      finance_track_very: included_entry.where(finance_track: 3).length,
      finance_track_missing: included_entry.where(finance_track: nil).or(included_entry.where(finance_track: 0)).length,
      finance_track_totals: included_entry.where.not(finance_track: nil).where.not(finance_track: 0).length,
      
      finance_cost_not: included_entry.where(finance_cost: 1).length,
      finance_cost_somewhat: included_entry.where(finance_cost: 2).length,
      finance_cost_very: included_entry.where(finance_cost: 3).length,
      finance_cost_missing: included_entry.where(finance_cost: nil).or(included_entry.where(finance_cost: 0)).length,
      finance_cost_totals: included_entry.where.not(finance_cost: nil).where.not(finance_cost: 0).length,
      
      talk_other_all: included_entry.where(talk_other: 1).length,
      talk_other_most: included_entry.where(talk_other: 2).length,
      talk_other_some: included_entry.where(talk_other: 3).length,
      talk_other_none: included_entry.where(talk_other: 4).length,
      talk_other_missing: included_entry.where(talk_other: nil).or(included_entry.where(talk_other: 0)).length,
      talk_other_totals: included_entry.where.not(talk_other: nil).where.not(talk_other: 0).length,
      
      talk_parent_all: included_entry.where(talk_parent: 1).length,
      talk_parent_most: included_entry.where(talk_parent: 2).length,
      talk_parent_some: included_entry.where(talk_parent: 3).length,
      talk_parent_none: included_entry.where(talk_parent: 4).length,
      talk_parent_missing: included_entry.where(talk_parent: nil).or(included_entry.where(talk_parent: 0)).length,
      talk_parent_totals: included_entry.where.not(talk_parent: nil).where.not(talk_parent: 0).length,
      
      relate_healthy_not: included_entry.where(relate_healthy: 1).length,
      relate_healthy_somewhat: included_entry.where(relate_healthy: 2).length,
      relate_healthy_very: included_entry.where(relate_healthy: 3).length,
      relate_healthy_missing: included_entry.where(relate_healthy: nil).or(included_entry.where(relate_healthy: 0)).length,
      relate_healthy_totals: included_entry.where.not(relate_healthy: nil).where.not(relate_healthy: 0).length,
      
      relate_resist_not: included_entry.where(relate_resist: 1).length,
      relate_resist_somewhat: included_entry.where(relate_resist: 2).length,
      relate_resist_very: included_entry.where(relate_resist: 3).length,
      relate_resist_missing: included_entry.where(relate_resist: nil).or(included_entry.where(relate_resist: 0)).length,
      relate_resist_totals: included_entry.where.not(relate_resist: nil).where.not(relate_resist: 0).length,
      
      relate_talk_not: included_entry.where(relate_talk: 1).length,
      relate_talk_somewhat: included_entry.where(relate_talk: 2).length,
      relate_talk_very: included_entry.where(relate_talk: 3).length,
      relate_talk_missing: included_entry.where(relate_talk: nil).or(included_entry.where(relate_talk: 0)).length,
      relate_talk_totals: included_entry.where.not(relate_talk: nil).where.not(relate_talk: 0).length,
      
      hadsex_yes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(hadsex: 1).length,
      hadsex_no: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(hadsex: 2).length,
      hadsex_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(hadsex: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(hadsex: nil)).length,
      hadsex_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #hadsex_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      hadsex_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(hadsex: [1, 2]).length,
      
      
      num_partners_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 1).length,
      num_partners_notrecently: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 2).length,
      num_partners_1: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 3).length,
      num_partners_2: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 4).length,
      num_partners_4: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 5).length,
      num_partners_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: nil)).length,
      num_partners_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #num_partners_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      num_partners_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(num_partners: [1, 2, 3, 4, 5]).length,
      
      condom_neversex: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 1).length,
      condom_notrecently: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 2).length,
      condom_always: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 3).length,
      condom_mostly: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 4).length,
      condom_sometimes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 5).length,
      condom_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: 6).length,
      condom_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: [0, nil]).length,
      condom_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #condom_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      condom_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(condom: [1, 2, 3, 4, 5, 6]).length,
      
      contraceptive_neversex: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 1).length,
      contraceptive_notrecently: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 2).length,
      contraceptive_always: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 3).length,
      contraceptive_mostly: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 4).length,
      contraceptive_sometimes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 5).length,
      contraceptive_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 6).length,
      contraceptive_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: nil)).length,
      contraceptive_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #contraceptive_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).or(included_entry.where(screen_grade: [1, 2, 3, 4, 5])).length,
      contraceptive_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(contraceptive: [1, 2, 3, 4, 5, 6]).length,
      
      preg_never: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: 1).length,
      preg_yes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: 2).length,
      preg_no: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: 3).length,
      preg_unsure: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: 4).length,
      preg_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: nil)).length,
      preg_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      preg_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(preg: [1, 2, 3, 4]).length,
      
      sti_yes: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(sti: 1).length,
      sti_no: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(sti: 2).length,
      sti_missing: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(sti: 0).or(included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(sti: nil)).length,
      sti_middle: included_entry.where(screen_grade: [1, 2, 3, 4, 5]).length,
      sti_totals: included_entry.where(screen_grade: [6, 7, 8, 9, 10]).where(sti: [1, 2]).length,
    }
    
    @results_exit = {
      total_ms: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      total_hs: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).length,
      total_all: included_exit.length,
      age_10: included_exit.where(m_age: 1).length + included_exit.where(h_age: 1).length,
      age_11: included_exit.where(m_age: 2).length + included_exit.where(h_age: 2).length,
      age_12: included_exit.where(m_age: 3).length + included_exit.where(h_age: 3).length,
      age_13: included_exit.where(m_age: 4).length + included_exit.where(h_age: 4).length,
      age_14: included_exit.where(m_age: 5).length + included_exit.where(h_age: 5).length,
      age_15: included_exit.where(m_age: 6).length + included_exit.where(h_age: 6).length,
      age_16: included_exit.where(m_age: 7).length + included_exit.where(h_age: 7).length,
      age_17: included_exit.where(h_age: 8).length,
      age_18: included_exit.where(h_age: 9).length,
      age_19: included_exit.where(h_age: 10).length,
      age_20: included_exit.where(h_age: 11).length,
      age_21: included_exit.where(h_age: 12).length,
      age_responses: included_exit.where.not(m_age: nil).or(included_exit.where.not(h_age: nil)).length,
      age_missing: included_exit.where(m_age: nil).where(h_age: nil).length,
      grade_5:            included_exit.where(m_grade: 1).length,
      grade_6:            included_exit.where(m_grade: 2).length,
      grade_7:            included_exit.where(m_grade: 3).length,
      grade_8:            included_exit.where(m_grade: 4).length,
      grade_9:            included_exit.where(m_grade: 5).length + included_exit.where(h_grade: 1).length,
      grade_10:                                                    included_exit.where(h_grade: 2).length,
      grade_11:                                                    included_exit.where(h_grade: 3).length,
      grade_12:                                                    included_exit.where(h_grade: 4).length,
      grade_ungraded:     included_exit.where(m_grade: 6).length + included_exit.where(h_grade: 5).length,
      grade_dropout:                                               included_exit.where(h_grade: 6).length,
      grade_getting_ged:                                           included_exit.where(h_grade: 7).length,
      grade_grad_nosec:                                            included_exit.where(h_grade: 8).length,
      grade_grad_sec:                                              included_exit.where(h_grade: 9).length,
      grade_not_in:       included_exit.where(m_grade: 7).length,
      grade_total:        included_exit.where.not(m_grade: [0, nil]).or(included_exit.where.not(h_grade: [0, nil])).length,
      grade_missing:      included_exit.where(m_grade: [0, nil]).where(h_grade: [0, nil]).length,
      lang_en: included_exit.where(lang_en: true).length,
      lang_sp: included_exit.where(lang_sp: true).length,
      lang_other: included_exit.where(lang_other: true).length,
      lang_other_txt: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count,
      lang_other_1: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 1 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[0] : [ "N/A" , 0 ],
      lang_other_2: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 2 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[1] : [ "N/A" , 0 ],
      lang_other_3: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 3 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[2] : [ "N/A" , 0 ],
      lang_other_4: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 4 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[3] : [ "N/A" , 0 ],
      lang_other_5: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 5 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[4] : [ "N/A" , 0 ],
      lang_other_6: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 6 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[5] : [ "N/A" , 0 ],
      lang_other_7: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 7 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[6] : [ "N/A" , 0 ],
      lang_other_8: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 8 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[7] : [ "N/A" , 0 ],
      lang_other_9: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 9 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[8] : [ "N/A" , 0 ],
      lang_other_10: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.length >= 10 ? included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a[9] : [ "N/A" , 0 ],
      lang_other_extra: included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.length > 10 ? 
                        included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.sum - included_exit.where(lang_other: true).group(:lang_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.first(10).sum : 
                        0,
      lang_other_totals: included_exit.where(lang_other: true).length,
      lang_total: included_exit.where(lang_en: true).or(included_exit.where(lang_sp: true)).or(included_exit.where(lang_other: true)).length,
      lang_missing: included_exit.where.not(lang_en: true).where.not(lang_sp: true).where.not(lang_other: true).length,
      ethnicity_sp: included_exit.where(is_hispanic: 1).length,
      ethnicity_not_sp: included_exit.where(is_hispanic: 2).length,
      ethnicity_total: included_exit.where.not(is_hispanic: nil).where.not(is_hispanic: 0).length,
      ethnicity_missing: included_exit.where(is_hispanic: nil).or(included_exit.where(is_hispanic: 0)).length,
      race_indian: included_exit.where(race_indian: true).length,
      race_asian: included_exit.where(race_asian: true).length,
      race_black: included_exit.where(race_black: true).length,
      race_pacific: included_exit.where(race_pacific: true).length,
      race_white: included_exit.where(race_white: true).length,
      race_other: included_entry.where(race_other: true).length,
      race_other_txt: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count,
      race_other_1: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 1 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[0] : [ "N/A" , 0 ],
      race_other_2: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 2 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[1] : [ "N/A" , 0 ],
      race_other_3: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 3 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[2] : [ "N/A" , 0 ],
      race_other_4: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 4 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[3] : [ "N/A" , 0 ],
      race_other_5: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 5 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[4] : [ "N/A" , 0 ],
      race_other_6: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 6 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[5] : [ "N/A" , 0 ],
      race_other_7: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 7 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[6] : [ "N/A" , 0 ],
      race_other_8: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 8 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[7] : [ "N/A" , 0 ],
      race_other_9: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 9 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[8] : [ "N/A" , 0 ],
      race_other_10: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.length >= 10 ? included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a[9] : [ "N/A" , 0 ],
      race_other_extra: included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.length > 10 ? 
                        included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.sum - included_entry.where(race_other: true).group(:race_other_txt).order('count(id) desc').count.to_a.map{|k, v| v}.first(10).sum : 
                        0,
      race_other_totals: included_entry.where(race_other: true).length,
      race_missing: included_exit.where.not(race_indian: true)
                                  .where.not(race_asian: true)
                                  .where.not(race_black: true)
                                  .where.not(race_pacific: true)
                                  .where.not(race_white: true)
                                  .where.not(race_other: true).length,
      race_totals: included_exit.where(race_indian: true).or(
                   included_exit.where(race_asian: true)).or(
                   included_exit.where(race_black: true)).or(
                   included_exit.where(race_pacific: true)).or(
                   included_exit.where(race_white: true)).or(
                   included_exit.where(race_other: true)).length,
      gender_m: included_exit.where(is_male: 1).length,
      gender_f: included_exit.where(is_male: 2).length,
      gender_totals: included_exit.where(is_male: 1).or(included_exit.where(is_male: 2)).length,
      gender_missing: included_exit.where(is_male: nil).or(included_exit.where(is_male: 0)).length,
      lives_family: included_exit.where(lives_family: true).length,
      lives_foster_family: included_exit.where(lives_foster_family: true).length,
      lives_foster_group: included_exit.where(lives_foster_group: true).length,
      lives_couch: included_exit.where(lives_couch: true).length,
      lives_outside: included_exit.where(lives_outside: true).length,
      lives_shelter: included_exit.where(lives_shelter: true).length,
      lives_hotel: included_exit.where(lives_hotel: true).length,
      lives_jail: included_exit.where(lives_jail: true).length,
      lives_none: included_exit.where(lives_none: true).length,
      lives_totals_family: included_exit.where(lives_family: true).length,
      lives_totals_foster: included_exit.where(lives_foster_family: true).or(included_exit.where(lives_foster_group: true)).length,
      lives_totals_homeless: included_exit.where(lives_couch: true).or(included_exit.where(lives_outside: true)).or(included_exit.where(lives_shelter: true)).or(included_exit.where(lives_hotel: true)).length,
      lives_totals_adjudicaton: included_exit.where(lives_jail: true).length,
      lives_totals_any: included_exit.where(lives_family: true)
                        .or(included_exit.where(lives_family: true))
                        .or(included_exit.where(lives_foster_family: true))
                        .or(included_exit.where(lives_foster_group: true))
                        .or(included_exit.where(lives_couch: true))
                        .or(included_exit.where(lives_outside: true))
                        .or(included_exit.where(lives_shelter: true))
                        .or(included_exit.where(lives_hotel: true))
                        .or(included_exit.where(lives_jail: true))
                        .length,
      lives_totals_missing: included_exit.where.not(lives_family: true)
                        .where.not(lives_family: true)
                        .where.not(lives_foster_family: true)
                        .where.not(lives_foster_group: true)
                        .where.not(lives_couch: true)
                        .where.not(lives_outside: true)
                        .where.not(lives_shelter: true)
                        .where.not(lives_hotel: true)
                        .where.not(lives_jail: true)
                        .length,
                        
      impact_behavior_peer_much_more: included_exit.where(impact_behavior_peer: 1).length,
      impact_behavior_peer_some_more: included_exit.where(impact_behavior_peer: 2).length,
      impact_behavior_peer_same: included_exit.where(impact_behavior_peer: 3).length,
      impact_behavior_peer_some_less: included_exit.where(impact_behavior_peer: 4).length,
      impact_behavior_peer_much_less: included_exit.where(impact_behavior_peer: 5).length,
      impact_behavior_peer_missing: included_exit.where(impact_behavior_peer: nil).or(included_exit.where(impact_behavior_peer: 0)).length,
      impact_behavior_peer_totals: included_exit.where.not(impact_behavior_peer: nil).where.not(impact_behavior_peer: 0).length,
      
      impact_behavior_emotion_much_more: included_exit.where(impact_behavior_emotion: 1).length,
      impact_behavior_emotion_some_more: included_exit.where(impact_behavior_emotion: 2).length,
      impact_behavior_emotion_same: included_exit.where(impact_behavior_emotion: 3).length,
      impact_behavior_emotion_some_less: included_exit.where(impact_behavior_emotion: 4).length,
      impact_behavior_emotion_much_less: included_exit.where(impact_behavior_emotion: 5).length,
      impact_behavior_emotion_missing: included_exit.where(impact_behavior_emotion: nil).or(included_exit.where(impact_behavior_emotion: 0)).length,
      impact_behavior_emotion_totals: included_exit.where.not(impact_behavior_emotion: nil).where.not(impact_behavior_emotion: 0).length,
    
      impact_behavior_alcohol_much_more: included_exit.where(impact_behavior_alcohol: 1).length,
      impact_behavior_alcohol_some_more: included_exit.where(impact_behavior_alcohol: 2).length,
      impact_behavior_alcohol_same: included_exit.where(impact_behavior_alcohol: 3).length,
      impact_behavior_alcohol_some_less: included_exit.where(impact_behavior_alcohol: 4).length,
      impact_behavior_alcohol_much_less: included_exit.where(impact_behavior_alcohol: 5).length,
      impact_behavior_alcohol_missing: included_exit.where(impact_behavior_alcohol: nil).or(included_exit.where(impact_behavior_alcohol: 0)).length,
      impact_behavior_alcohol_totals: included_exit.where.not(impact_behavior_alcohol: nil).where.not(impact_behavior_alcohol: 0).length,
      
      impact_behavior_think_much_more: included_exit.where(impact_behavior_think: 1).length,
      impact_behavior_think_some_more: included_exit.where(impact_behavior_think: 2).length,
      impact_behavior_think_same: included_exit.where(impact_behavior_think: 3).length,
      impact_behavior_think_some_less: included_exit.where(impact_behavior_think: 4).length,
      impact_behavior_think_much_less: included_exit.where(impact_behavior_think: 5).length,
      impact_behavior_think_missing: included_exit.where(impact_behavior_think: nil).or(included_exit.where(impact_behavior_think: 0)).length,
      impact_behavior_think_totals: included_exit.where.not(impact_behavior_think: nil).where.not(impact_behavior_think: 0).length,
      
      impact_intent_plans_much_more: included_exit.where(impact_intent_plans: 1).length,
      impact_intent_plans_some_more: included_exit.where(impact_intent_plans: 2).length,
      impact_intent_plans_same: included_exit.where(impact_intent_plans: 3).length,
      impact_intent_plans_some_less: included_exit.where(impact_intent_plans: 4).length,
      impact_intent_plans_much_less: included_exit.where(impact_intent_plans: 5).length,
      impact_intent_plans_missing: included_exit.where(impact_intent_plans: nil).or(included_exit.where(impact_intent_plans: 0)).length,
      impact_intent_plans_totals: included_exit.where.not(impact_intent_plans: nil).where.not(impact_intent_plans: 0).length,
      
      impact_intent_study_much_more: included_exit.where(impact_intent_study: 1).length,
      impact_intent_study_some_more: included_exit.where(impact_intent_study: 2).length,
      impact_intent_study_same: included_exit.where(impact_intent_study: 3).length,
      impact_intent_study_some_less: included_exit.where(impact_intent_study: 4).length,
      impact_intent_study_much_less: included_exit.where(impact_intent_study: 5).length,
      impact_intent_study_missing: included_exit.where(impact_intent_study: nil).or(included_exit.where(impact_intent_study: 0)).length,
      impact_intent_study_totals: included_exit.where.not(impact_intent_study: nil).where.not(impact_intent_study: 0).length,
      
      impact_intent_graduate_much_more: included_exit.where(impact_intent_graduate: 1).length,
      impact_intent_graduate_some_more: included_exit.where(impact_intent_graduate: 2).length,
      impact_intent_graduate_same: included_exit.where(impact_intent_graduate: 3).length,
      impact_intent_graduate_some_less: included_exit.where(impact_intent_graduate: 4).length,
      impact_intent_graduate_much_less: included_exit.where(impact_intent_graduate: 5).length,
      impact_intent_graduate_missing: included_exit.where(impact_intent_graduate: nil).or(included_exit.where(impact_intent_graduate: 0)).length,
      impact_intent_graduate_totals: included_exit.where.not(impact_intent_graduate: nil).where.not(impact_intent_graduate: 0).length,
      
      impact_intent_more_study_much_more: included_exit.where(impact_intent_more_study: 1).length,
      impact_intent_more_study_some_more: included_exit.where(impact_intent_more_study: 2).length,
      impact_intent_more_study_same: included_exit.where(impact_intent_more_study: 3).length,
      impact_intent_more_study_some_less: included_exit.where(impact_intent_more_study: 4).length,
      impact_intent_more_study_much_less: included_exit.where(impact_intent_more_study: 5).length,
      impact_intent_more_study_missing: included_exit.where(impact_intent_more_study: nil).or(included_exit.where(impact_intent_more_study: 0)).length,
      impact_intent_more_study_totals: included_exit.where.not(impact_intent_more_study: nil).where.not(impact_intent_more_study: 0).length,
      
      impact_intent_work_much_more: included_exit.where(impact_intent_work: 1).length,
      impact_intent_work_some_more: included_exit.where(impact_intent_work: 2).length,
      impact_intent_work_same: included_exit.where(impact_intent_work: 3).length,
      impact_intent_work_some_less: included_exit.where(impact_intent_work: 4).length,
      impact_intent_work_much_less: included_exit.where(impact_intent_work: 5).length,
      impact_intent_work_missing: included_exit.where(impact_intent_work: [0, nil]).length,
      impact_intent_work_totals: included_exit.where(impact_intent_work: [1, 2, 3, 4, 5]).length,
      
      impact_finance_save_much_more: included_exit.where(impact_finance_save: 1).length,
      impact_finance_save_some_more: included_exit.where(impact_finance_save: 2).length,
      impact_finance_save_same: included_exit.where(impact_finance_save: 3).length,
      impact_finance_save_some_less: included_exit.where(impact_finance_save: 4).length,
      impact_finance_save_much_less: included_exit.where(impact_finance_save: 5).length,
      impact_finance_save_missing: included_exit.where(impact_finance_save: nil).or(included_exit.where(impact_finance_save: 0)).length,
      impact_finance_save_totals: included_exit.where.not(impact_finance_save: nil).where.not(impact_finance_save: 0).length,
      
      impact_finance_bank_much_more: included_exit.where(impact_finance_bank: 1).length,
      impact_finance_bank_some_more: included_exit.where(impact_finance_bank: 2).length,
      impact_finance_bank_same: included_exit.where(impact_finance_bank: 3).length,
      impact_finance_bank_some_less: included_exit.where(impact_finance_bank: 4).length,
      impact_finance_bank_much_less: included_exit.where(impact_finance_bank: 5).length,
      impact_finance_bank_missing: included_exit.where(impact_finance_bank: nil).or(included_exit.where(impact_finance_bank: 0)).length,
      impact_finance_bank_totals: included_exit.where.not(impact_finance_bank: nil).where.not(impact_finance_bank: 0).length,
      
      impact_finance_budget_much_more: included_exit.where(impact_finance_budget: 1).length,
      impact_finance_budget_some_more: included_exit.where(impact_finance_budget: 2).length,
      impact_finance_budget_same: included_exit.where(impact_finance_budget: 3).length,
      impact_finance_budget_some_less: included_exit.where(impact_finance_budget: 4).length,
      impact_finance_budget_much_less: included_exit.where(impact_finance_budget: 5).length,
      impact_finance_budget_missing: included_exit.where(impact_finance_budget: nil).or(included_exit.where(impact_finance_budget: 0)).length,
      impact_finance_budget_totals: included_exit.where.not(impact_finance_budget: nil).where.not(impact_finance_budget: 0).length,
      
      impact_finance_track_much_more: included_exit.where(impact_finance_track: 1).length,
      impact_finance_track_some_more: included_exit.where(impact_finance_track: 2).length,
      impact_finance_track_same: included_exit.where(impact_finance_track: 3).length,
      impact_finance_track_some_less: included_exit.where(impact_finance_track: 4).length,
      impact_finance_track_much_less: included_exit.where(impact_finance_track: 5).length,
      impact_finance_track_missing: included_exit.where(impact_finance_track: nil).or(included_exit.where(impact_finance_track: 0)).length,
      impact_finance_track_totals: included_exit.where.not(impact_finance_track: nil).where.not(impact_finance_track: 0).length,
      
      impact_finance_cost_much_more: included_exit.where(impact_finance_cost: 1).length,
      impact_finance_cost_some_more: included_exit.where(impact_finance_cost: 2).length,
      impact_finance_cost_same: included_exit.where(impact_finance_cost: 3).length,
      impact_finance_cost_some_less: included_exit.where(impact_finance_cost: 4).length,
      impact_finance_cost_much_less: included_exit.where(impact_finance_cost: 5).length,
      impact_finance_cost_missing: included_exit.where(impact_finance_cost: nil).or(included_exit.where(impact_finance_cost: 0)).length,
      impact_finance_cost_totals: included_exit.where.not(impact_finance_cost: nil).where.not(impact_finance_cost: 0).length,
      
      impact_talk_parent_much_more: included_exit.where(impact_talk_parent: 1).length,
      impact_talk_parent_some_more: included_exit.where(impact_talk_parent: 2).length,
      impact_talk_parent_same: included_exit.where(impact_talk_parent: 3).length,
      impact_talk_parent_some_less: included_exit.where(impact_talk_parent: 4).length,
      impact_talk_parent_much_less: included_exit.where(impact_talk_parent: 5).length,
      impact_talk_parent_missing: included_exit.where(impact_talk_parent: nil).or(included_exit.where(impact_talk_parent: 0)).length,
      impact_talk_parent_totals: included_exit.where.not(impact_talk_parent: nil).where.not(impact_talk_parent: 0).length,
      
      impact_talk_other_much_more: included_exit.where(impact_talk_other: 1).length,
      impact_talk_other_some_more: included_exit.where(impact_talk_other: 2).length,
      impact_talk_other_same: included_exit.where(impact_talk_other: 3).length,
      impact_talk_other_some_less: included_exit.where(impact_talk_other: 4).length,
      impact_talk_other_much_less: included_exit.where(impact_talk_other: 5).length,
      impact_talk_other_missing: included_exit.where(impact_talk_other: nil).or(included_exit.where(impact_talk_other: 0)).length,
      impact_talk_other_totals: included_exit.where.not(impact_talk_other: nil).where.not(impact_talk_other: 0).length,
      
      impact_relate_healthy_much_more: included_exit.where(impact_relate_healthy: 1).length,
      impact_relate_healthy_some_more: included_exit.where(impact_relate_healthy: 2).length,
      impact_relate_healthy_same: included_exit.where(impact_relate_healthy: 3).length,
      impact_relate_healthy_some_less: included_exit.where(impact_relate_healthy: 4).length,
      impact_relate_healthy_much_less: included_exit.where(impact_relate_healthy: 5).length,
      impact_relate_healthy_missing: included_exit.where(impact_relate_healthy: nil).or(included_exit.where(impact_relate_healthy: 0)).length,
      impact_relate_healthy_totals: included_exit.where.not(impact_relate_healthy: nil).where.not(impact_relate_healthy: 0).length,
      
      impact_relate_resist_much_more: included_exit.where(impact_relate_resist: 1).length,
      impact_relate_resist_some_more: included_exit.where(impact_relate_resist: 2).length,
      impact_relate_resist_same: included_exit.where(impact_relate_resist: 3).length,
      impact_relate_resist_some_less: included_exit.where(impact_relate_resist: 4).length,
      impact_relate_resist_much_less: included_exit.where(impact_relate_resist: 5).length,
      impact_relate_resist_missing: included_exit.where(impact_relate_resist: nil).or(included_exit.where(impact_relate_resist: 0)).length,
      impact_relate_resist_totals: included_exit.where.not(impact_relate_resist: nil).where.not(impact_relate_resist: 0).length,
      
      impact_relate_talk_much_more: included_exit.where(impact_relate_talk: 1).length,
      impact_relate_talk_some_more: included_exit.where(impact_relate_talk: 2).length,
      impact_relate_talk_same: included_exit.where(impact_relate_talk: 3).length,
      impact_relate_talk_some_less: included_exit.where(impact_relate_talk: 4).length,
      impact_relate_talk_much_less: included_exit.where(impact_relate_talk: 5).length,
      impact_relate_talk_missing: included_exit.where(impact_relate_talk: nil).or(included_exit.where(impact_relate_talk: 0)).length,
      impact_relate_talk_totals: included_exit.where.not(impact_relate_talk: nil).where.not(impact_relate_talk: 0).length,
      
      plan_abstainsex_yes: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
      plan_abstainsex_no: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 2).length,
      plan_abstainsex_unsure: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 3).length,
      plan_abstainsex_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 0).or(included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: nil)).length,
      plan_abstainsex_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #plan_abstainsex_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).or(included_exit.where(screen_grade: [1, 2, 3, 4, 5])).length,
      plan_abstainsex_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [1, 2, 3]).length,
      
      abstain_yes_plans_not_any: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_plans: 1).length,
      abstain_yes_plans_not_too_much: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_plans: 2).length,
      abstain_yes_plans_somewhat: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_plans: 3).length,
      abstain_yes_plans_very: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_plans: 4).length,
      abstain_yes_plans_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 1]).where(abstain_yes_plans: [nil, 0]).length,
      abstain_yes_plans_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_yes_plans_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where.not(abstain_yes_plans: 0).where.not(abstain_yes_plans: nil).length,
      abstain_yes_plans_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_plans: [1, 2, 3, 4]).length,
      abstain_yes_plans_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).length,
      
      abstain_yes_consequences_not_any: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_consequences: 1).length,
      abstain_yes_consequences_not_too_much: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_consequences: 2).length,
      abstain_yes_consequences_somewhat: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_consequences: 3).length,
      abstain_yes_consequences_very: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_consequences: 4).length,
      abstain_yes_consequences_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 1]).where(abstain_yes_consequences: [nil, 0]).length,
      abstain_yes_consequences_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_yes_consequences_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where.not(abstain_yes_consequences: 0).where.not(abstain_yes_consequences: nil).length,
      abstain_yes_consequences_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_consequences: [1, 2, 3, 4]).length,
      abstain_yes_consequences_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).length,
      
      abstain_yes_sti_not_any: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_sti: 1).length,
      abstain_yes_sti_not_too_much: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_sti: 2).length,
      abstain_yes_sti_somewhat: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_sti: 3).length,
      abstain_yes_sti_very: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_sti: 4).length,
      abstain_yes_sti_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 1]).where(abstain_yes_sti: [nil, 0]).length,
      abstain_yes_sti_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_yes_sti_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where.not(abstain_yes_sti: 0).where.not(abstain_yes_sti: nil).length,
      abstain_yes_sti_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_sti: [1, 2, 3, 4]).length,
      abstain_yes_sti_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).length,
      
      abstain_yes_preg_not_any: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_preg: 1).length,
      abstain_yes_preg_not_too_much: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_preg: 2).length,
      abstain_yes_preg_somewhat: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_preg: 3).length,
      abstain_yes_preg_very: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_preg: 4).length,
      abstain_yes_preg_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 1]).where(abstain_yes_preg: [0, nil]).length,
      abstain_yes_preg_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_yes_preg_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where.not(abstain_yes_preg: 0).where.not(abstain_yes_preg: nil).length,
      abstain_yes_preg_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).where(abstain_yes_preg: [1, 2, 3, 4]).length,
      abstain_yes_preg_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).length,
      
      abstain_notyes_havesex_much_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_havesex: 1).length,
      abstain_notyes_havesex_some_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_havesex: 2).length,
      abstain_notyes_havesex_same: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_havesex: 3).length,
      abstain_notyes_havesex_some_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_havesex: 4).length,
      abstain_notyes_havesex_much_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_havesex: 5).length,
      abstain_notyes_havesex_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 2, 3]).where(abstain_notyes_havesex: [0, nil]).length,
      abstain_notyes_havesex_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_notyes_havesex_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where.not(abstain_notyes_havesex: 0).where.not(abstain_notyes_havesex: nil).length,
      abstain_notyes_havesex_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where(abstain_notyes_havesex: [1, 2, 3, 4, 5]).length,
      abstain_notyes_havesex_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
      
      abstain_notyes_condom_not_applicable: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 1).length,
      abstain_notyes_condom_much_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 2).length,
      abstain_notyes_condom_some_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 3).length,
      abstain_notyes_condom_same: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 4).length,
      abstain_notyes_condom_some_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 5).length,
      abstain_notyes_condom_much_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: 6).length,
      abstain_notyes_condom_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 2, 3]).where(abstain_notyes_condom: [0, nil]).length,
      abstain_notyes_condom_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_notyes_condom_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where.not(abstain_notyes_condom: 0).where.not(abstain_notyes_condom: nil).length,
      abstain_notyes_condom_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_condom: [1, 2, 3, 4, 5, 6]).length,
      abstain_notyes_condom_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
      
      abstain_notyes_contra_not_applicable: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 1).length,
      abstain_notyes_contra_much_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 2).length,
      abstain_notyes_contra_some_more: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 3).length,
      abstain_notyes_contra_same: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 4).length,
      abstain_notyes_contra_some_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 5).length,
      abstain_notyes_contra_much_less: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: 6).length,
      abstain_notyes_contra_missing: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [0, nil, 2, 3]).where(abstain_notyes_contra: [0, nil]).length,
      abstain_notyes_contra_middle: included_exit.where(screen_grade: [1, 2, 3, 4, 5]).length,
      #abstain_notyes_contra_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where.not(plan_abstainsex: 1).where.not(abstain_notyes_contra: 0).where.not(abstain_notyes_contra: nil).length,
      abstain_notyes_contra_totals: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: [2, 3]).where(abstain_notyes_contra: [1, 2, 3, 4, 5, 6]).length,
      abstain_notyes_contra_skipped: included_exit.where(screen_grade: [6, 7, 8, 9, 10]).where(plan_abstainsex: 1).length,
    
      percep_interest_all: included_exit.where(percep_interest: 1).length,
      percep_interest_most: included_exit.where(percep_interest: 2).length,
      percep_interest_some: included_exit.where(percep_interest: 3).length,
      percep_interest_none: included_exit.where(percep_interest: 4).length,
      percep_interest_missing: included_exit.where(percep_interest: 0).or(included_exit.where(percep_interest: nil)).length,
      percep_interest_totals: included_exit.where.not(percep_interest: 0).where.not(percep_interest: nil).length,
      
      percep_clear_all: included_exit.where(percep_clear: 1).length,
      percep_clear_most: included_exit.where(percep_clear: 2).length,
      percep_clear_some: included_exit.where(percep_clear: 3).length,
      percep_clear_none: included_exit.where(percep_clear: 4).length,
      percep_clear_missing: included_exit.where(percep_clear: 0).or(included_exit.where(percep_clear: nil)).length,
      percep_clear_totals: included_exit.where.not(percep_clear: 0).where.not(percep_clear: nil).length,
      
      percep_learn_all: included_exit.where(percep_learn: 1).length,
      percep_learn_most: included_exit.where(percep_learn: 2).length,
      percep_learn_some: included_exit.where(percep_learn: 3).length,
      percep_learn_none: included_exit.where(percep_learn: 4).length,
      percep_learn_missing: included_exit.where(percep_learn: 0).or(included_exit.where(percep_learn: nil)).length,
      percep_learn_totals: included_exit.where.not(percep_learn: 0).where.not(percep_learn: nil).length,
      
      percep_ask_all: included_exit.where(percep_ask: 1).length,
      percep_ask_most: included_exit.where(percep_ask: 2).length,
      percep_ask_some: included_exit.where(percep_ask: 3).length,
      percep_ask_none: included_exit.where(percep_ask: 4).length,
      percep_ask_missing: included_exit.where(percep_ask: 0).or(included_exit.where(percep_ask: nil)).length,
      percep_ask_totals: included_exit.where.not(percep_ask: 0).where.not(percep_ask: nil).length,
      
      percep_respect_all: included_exit.where(percep_respect: 1).length,
      percep_respect_most: included_exit.where(percep_respect: 2).length,
      percep_respect_some: included_exit.where(percep_respect: 3).length,
      percep_respect_none: included_exit.where(percep_respect: 4).length,
      percep_respect_missing: included_exit.where(percep_respect: 0).or(included_exit.where(percep_respect: nil)).length,
      percep_respect_totals: included_exit.where.not(percep_respect: 0).where.not(percep_respect: nil).length,
      
      satisfaction_abstain_very: included_exit.where(satisfaction_abstain: 1).length,
      satisfaction_abstain_somewhat: included_exit.where(satisfaction_abstain: 2).length,
      satisfaction_abstain_little: included_exit.where(satisfaction_abstain: 3).length,
      satisfaction_abstain_notatall: included_exit.where(satisfaction_abstain: 4).length,
      satisfaction_abstain_missing: included_exit.where(satisfaction_abstain: 0).or(included_exit.where(satisfaction_abstain: nil)).length,
      satisfaction_abstain_totals: included_exit.where.not(satisfaction_abstain: 0).where.not(satisfaction_abstain: nil).length,
      
      satisfaction_contra_very: included_exit.where(satisfaction_contra: 1).length,
      satisfaction_contra_somewhat: included_exit.where(satisfaction_contra: 2).length,
      satisfaction_contra_little: included_exit.where(satisfaction_contra: 3).length,
      satisfaction_contra_notatall: included_exit.where(satisfaction_contra: 4).length,
      satisfaction_contra_missing: included_exit.where(satisfaction_contra: 0).or(included_exit.where(satisfaction_contra: nil)).length,
      satisfaction_contra_totals: included_exit.where.not(satisfaction_contra: 0).where.not(satisfaction_contra: nil).length
    }
  end
  
  def mpr_helper
    authorize :report, :mpr_helper?
    
    #scoped_sessions = policy_scope(SessionLog)
    scoped_cohorts = policy_scope(Cohort)
    #scoped_providers = policy_scope(Provider)
    #scoped_sessions = SessionLog.where("extract(year from happened_on) = ? and extract(month from happened_on) <= ?", (Date.current - 1.month).year, (Date.current - 1.month).month).order(:cohort_id)
    #policy_scope(Cohort)
    scoped_providers = policy_scope(Provider).order(:period, :pmms_aggregate_name, :long_name).select(:id, :period, :pmms_aggregate_name, :long_name)
    scoped_cohorts = policy_scope(Cohort).joins(:coho_up).where.missing(:coho_down).select(:id, :provider_id, :intended_start, :intended_finish, :intended_session_count, :name, :extra_name).order(:provider_id, :name, :extra_name)
    scoped_logs = policy_scope(SessionLog)
    scoped_downs = policy_scope(CohoDown)

    my_data = Array.new()
    scoped_providers.each() { |i| my_data.push(
      provider: i,
      all_initiates: (scoped_logs.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:newface_ms_headcount) + scoped_logs.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:newface_hs_headcount)).sum,
      all_graduates: (scoped_downs.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:total_graduated_ms) + scoped_downs.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:total_graduated_hs)).sum,
      all_entry: EntrySurvey.where(magic: CohoUp.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:magic_code)).length,
      all_exit: ExitSurvey.where(magic: CohoUp.where(cohort_id: policy_scope(Cohort).where(provider_id: i.id).pluck(:id)).pluck(:magic_code)).length,
      cohorts: scoped_cohorts.where(provider_id: i.id).map{ |j| {
        cohort: j,
        initiates: (j.session_logs.pluck(:newface_ms_headcount) + j.session_logs.pluck(:newface_hs_headcount)).sum,
        attendances: (j.session_logs.pluck(:middleschool_headcount) + j.session_logs.pluck(:highschool_headcount)).sum,
        observed_sessions: j.session_logs.length,
        expected_sessions: j.intended_start < Date.current ? (j.intended_session_count * [1, ((Date.current - j.intended_start) / (j.intended_finish - j.intended_start).to_f)].min).to_i : 0,
        passes_muster: j.session_logs.length >= (j.intended_start < Date.current ? (j.intended_session_count * [1, ((Date.current - j.intended_start) / (j.intended_finish - j.intended_start).to_f)].min).to_i : 0)
        }}
      )}  
    
    @results = my_data    
  end
  
  def ppr_csv_cbo
    authorize :report, :view?

    if params[:start].nil?
      @window_start = "2021-10-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2022-03-31"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    scoped_cohorts = policy_scope(Cohort)

    concerned_cohorts = ( SessionLog.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck("cohort_id").sort.uniq +
      CohoDown.where(id: CohoDownAttend.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck(:coho_down_id).sort.uniq).pluck(:cohort_id).sort.uniq
    ).sort.uniq
    
    concerned_providers_cbo = Provider.where("providers.id in (?) and providers.pmms_aggregate_name != 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq
    concerned_providers_ahyd = Provider.where("providers.id in (?) and providers.pmms_aggregate_name = 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq

    concerned_cohorts_cbo = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_cbo).order(:provider_id, :name)
    concerned_cohorts_ahyd = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_ahyd).order(:provider_id, :name)
    
    def get_bigger(everyone, who, what)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          this_cohort.coho_up[what]
        else
          if this_cohort.coho_down[:ppr_count_total] >= this_cohort.coho_up[:ppr_count_total]
            this_cohort.coho_down[what]
          else
            this_cohort.coho_up[what]
          end
        end
      }
      return my_findings.sum
    end
    
    def get_grads(everyone, who)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          0
        else
            this_cohort.coho_down[:total_graduated_ms] + this_cohort.coho_down[:total_graduated_hs]
        end
      }
      return my_findings.sum
    end

    
    @ppr_data = concerned_cohorts_cbo.pluck(:name).uniq.map { |i| {
     n_provider: concerned_cohorts_cbo.where(name: i).first.provider.long_name,
     n_site: i,
     n_unclosed: concerned_cohorts_cbo.where(name: i).where.missing(:coho_down).length > 0 ? true : false,
     n_initiated: get_bigger(concerned_cohorts_cbo, i, "ppr_count_total"),
     n_graduated: get_grads(concerned_cohorts_cbo, i),
     n_male: get_bigger(concerned_cohorts_cbo, i, "ppr_count_male"),
     n_female: get_bigger(concerned_cohorts_cbo, i, "ppr_count_female"),
     n_10: get_bigger(concerned_cohorts_cbo, i, "ppr_count_10_13"),
     n_14: get_bigger(concerned_cohorts_cbo, i, "ppr_count_14_19"),
     n_20: get_bigger(concerned_cohorts_cbo, i, "ppr_count_20"),
     n_preg: get_bigger(concerned_cohorts_cbo, i, "ppr_count_preg_par"),
     n_justice: get_bigger(concerned_cohorts_cbo, i, "ppr_count_juv_jus"),
     n_foster: get_bigger(concerned_cohorts_cbo, i, "ppr_count_foster"),
     n_runaway: get_bigger(concerned_cohorts_cbo, i, "ppr_count_runaway"),
     n_lgbt: get_bigger(concerned_cohorts_cbo, i, "ppr_count_lgbt")
    }}
    
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=ppr-cbo.csv"
    render template: "reports/ppr_csv.csv.erb"
  end
  
  def ppr_csv_ahyd
    authorize :report, :view?

    if params[:start].nil?
      @window_start = "2021-10-01"
    else
      @window_start = params[:start]
    end
    if params[:stop].nil?
      @window_stop = "2022-03-31"
    else
      @window_stop = params[:stop]
    end

    y, m, d = @window_start.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Start date was invalid.'
      redirect_to root_path
    else
      @window_start = Date.new(y.to_i, m.to_i, d.to_i)
    end

    y, m, d = @window_stop.split '-'
    if !Date.valid_date? y.to_i, m.to_i, d.to_i
      flash[:danger] = 'Stop date was invalid.'
      redirect_to root_path
    else
      @window_stop = Date.new(y.to_i, m.to_i, d.to_i)
    end
    scoped_cohorts = policy_scope(Cohort)

    concerned_cohorts = ( SessionLog.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck("cohort_id").sort.uniq +
      CohoDown.where(id: CohoDownAttend.where("happened_on >= ? AND happened_on <= ?", @window_start, @window_stop).pluck(:coho_down_id).sort.uniq).pluck(:cohort_id).sort.uniq
    ).sort.uniq
    
    concerned_providers_cbo = Provider.where("providers.id in (?) and providers.pmms_aggregate_name != 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq
    concerned_providers_ahyd = Provider.where("providers.id in (?) and providers.pmms_aggregate_name = 'AHYD' and is_test = FALSE", Cohort.where(id: concerned_cohorts).pluck(:provider_id).sort.uniq).pluck(:id).sort.uniq

    concerned_cohorts_cbo = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_cbo).order(:provider_id, :name)
    concerned_cohorts_ahyd = scoped_cohorts.where("cohorts.id in (?) and cohorts.provider_id in (?)", concerned_cohorts, concerned_providers_ahyd).order(:provider_id, :name)
    
    def get_bigger(everyone, who, what)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          this_cohort.coho_up[what]
        else
          if this_cohort.coho_down[:ppr_count_total] >= this_cohort.coho_up[:ppr_count_total]
            this_cohort.coho_down[what]
          else
            this_cohort.coho_up[what]
          end
        end
      }
      return my_findings.sum
    end
    
    def get_grads(everyone, who)
      my_concerns = everyone.where(name: who)
      my_findings = my_concerns.map {|this_cohort|
        if this_cohort.coho_down.nil?
          0
        else
            this_cohort.coho_down[:total_graduated_ms] + this_cohort.coho_down[:total_graduated_hs]
        end
      }
      return my_findings.sum
    end

    @ppr_data = concerned_cohorts_ahyd.pluck(:name).uniq.map { |i| {
     n_provider: concerned_cohorts_ahyd.where(name: i).first.provider.long_name,
     n_site: i,
     n_unclosed: concerned_cohorts_ahyd.where(name: i).where.missing(:coho_down).length > 0 ? true : false,
     n_initiated: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_total"),
     n_graduated: get_grads(concerned_cohorts_ahyd, i),
     n_male: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_male"),
     n_female: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_female"),
     n_10: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_10_13"),
     n_14: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_14_19"),
     n_20: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_20"),
     n_preg: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_preg_par"),
     n_justice: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_juv_jus"),
     n_foster: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_foster"),
     n_runaway: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_runaway"),
     n_lgbt: get_bigger(concerned_cohorts_ahyd, i, "ppr_count_lgbt")
    }}

    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=ppr-ahyd.csv"
    render :template => "reports/ppr_csv.csv.erb", :locals => { ppr_data: @ppr_data}
  end
  
  private
  
  def report_params
    params.permit(:start, :stop)
  end
end

