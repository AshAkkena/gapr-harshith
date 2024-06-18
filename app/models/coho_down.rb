class CohoDown < ApplicationRecord
  belongs_to :cohort
  after_save_commit :bake_diagnostics
  has_paper_trail
  has_many :coho_down_attends, dependent: :destroy
  accepts_nested_attributes_for :coho_down_attends, allow_destroy: true, reject_if: :all_blank

  validates :cohort_id, presence: true
  validates :main_setting, presence: true
  validates :total_graduated_ms, numericality: { greater_than_or_equal_to: 0 }
  validates :total_graduated_hs, numericality: { greater_than_or_equal_to: 0 }
  validates :total_initiated_ms, numericality: { greater_than_or_equal_to: 0 }
  validates :total_initiated_hs, numericality: { greater_than_or_equal_to: 0 }
  validates :total_hours_delivered, numericality: { greater_than_or_equal_to: 0 }
  validates :census_foster, numericality: { greater_than_or_equal_to: 0 }
  validates :census_homeless, numericality: { greater_than_or_equal_to: 0 }
  validates :census_pregnant_parenting, numericality: { greater_than_or_equal_to: 0 }
  validates :census_adjudication, numericality: { greater_than_or_equal_to: 0 }
  validates :ppr_count_male, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_female, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_10_13, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_14_19, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_20, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_preg_par, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_juv_jus, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_foster, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_runaway, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_lgbt, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_total, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.ppr_count_total } }
  validates :ppr_count_total, isSumOf: [ :ppr_count_male, :ppr_count_female ]
  validates :ppr_count_total, isSumOf: [ :ppr_count_10_13, :ppr_count_14_19, :ppr_count_20 ]
  has_one_attached :receipt
  
  validate :uniqueness_of_sessions
  validate :receipt_check
  
  #before_validation :dummy_code_enrollment
  
  #def dummy_code_enrollment
  #  if cohort
  #    if cohort.uses_enrollment?
        #self.middleschool_headcount = cohort.enrollments.where('age < 18').where(id: self.enrollment_ids).length
        #self.highschool_headcount = cohort.enrollments.where('age >= 18').where(id: self.enrollment_ids).length
        #self.newface_ms_headcount = cohort.youth_newfaces.where(id: self.enrollment_ids).length
        #self.newface_hs_headcount = cohort.adult_newfaces.where(id: self.enrollment_ids).length
        #errors[:base] << 'Something went wrong with enrollment.'
  #    end
  #  end
  #end
  
  def graduate_ids
    self.cohort.enrollments.where(graduate: true).pluck(:id)
  end  
  def graduate_ids=(value)
    self.cohort.enrollments.where.not(id: value).update_all(graduate: false)
    self.cohort.enrollments.where(id: value).update_all(graduate: true)
  end 
  
  private
  
  def uniqueness_of_sessions
    errors.add(:coho_down_attends, 'must be unique') if coho_down_attends.map(&:happened_on).uniq.size != coho_down_attends.size
  end
  
   def bake_diagnostics
    @cohort = Cohort.find_by_id(self[:cohort_id])
    
    my_dates = (@cohort.session_logs.pluck(:happened_on) + @cohort.coho_down.coho_down_attends.pluck(:happened_on)).uniq.sort
    agreements = my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["middleschool_headcount"] : 0) == (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["middleschool_headcount"] : 0)) ? 1 : 0
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["newface_ms_headcount"] : 0) == (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["newface_ms_headcount"] : 0)) ? 1 : 0
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["highschool_headcount"] : 0) == (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["highschool_headcount"] : 0)) ? 1 : 0
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["newface_hs_headcount"] : 0) == (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["newface_hs_headcount"] : 0)) ? 1 : 0
    }.sum 
    irr = ((agreements / (my_dates.length * 4).to_f).round(2) * 100 ).to_i

    drift = (my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["middleschool_headcount"] : 0) - (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["middleschool_headcount"] : 0))
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["newface_ms_headcount"] : 0) - (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["newface_ms_headcount"] : 0))
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["highschool_headcount"] : 0) - (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["highschool_headcount"] : 0))
    }.sum +
    my_dates.map{
      |d| ((@cohort.session_logs.find_by("happened_on = ?", d).present? ? @cohort.session_logs.find_by("happened_on = ?", d)["newface_hs_headcount"] : 0) - (@cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d).present? ? @cohort.coho_down.coho_down_attends.find_by("happened_on = ?", d)["newface_hs_headcount"] : 0))
    }.sum).abs 
    @cohort.update_column(:reliable_stat, irr) # This will skip validation gracefully.
    @cohort.update_column(:drift_stat, drift) # This will skip validation gracefully.
  end
  
  def receipt_check
    if receipt.attached?
      if receipt.blob.byte_size > 10000000
#        receipt.purge <- not needed with rails 6
        errors[:base] << 'File attachment too big'
      end
    end
  end
end
