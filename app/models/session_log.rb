class SessionLog < ApplicationRecord
  belongs_to :cohort
  has_paper_trail
  has_many :session_modules, dependent: :destroy
  has_many :module_lookups, through: :session_modules
  has_one :provider, through: :cohort
  has_many :enrollment_session_logs, dependent: :destroy
  has_many :enrollments, through: :enrollment_session_logs
  has_one_attached :receipt
  #before_validation :bodge_enrollment
  #before_create :check_and_fix_enrollment
  
  before_validation :dummy_code_enrollment
  
  validates :receipt, presence: true
  validates :period, presence: true
  validates :magic_code, presence: true
  validates :cohort_id, presence: true
  validates :happened_on, presence: true, uniqueness: { scope: :cohort_id }
  validates :minutes_taught, numericality: { greater_than_or_equal_to: 0 }
  validates :middleschool_headcount, numericality: { greater_than_or_equal_to: 0 }
  validates :highschool_headcount, numericality: { greater_than_or_equal_to: 0 }
  validates :newface_ms_headcount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.middleschool_headcount } }
  validates :newface_hs_headcount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.highschool_headcount } }
  validates :facilitator_initial, presence: true
  validates :participantion_proportion, presence: true
  validates :interest_proportion, presence: true
  validates :impl_setting, presence: true
  validate :receipt_check
  
#  validate :uniqueness_of_sessions
  def dummy_code_enrollment
    if cohort
      if cohort.uses_enrollment?
        #validates :middleschool_headcount
        #validates :highschool_headcount
        #validates :newface_ms_headcount
        #validates :newface_hs_headcount
        self.middleschool_headcount = cohort.enrollments.where('age < 18').where(id: self.enrollment_ids).length
        self.highschool_headcount = cohort.enrollments.where('age >= 18').where(id: self.enrollment_ids).length
        self.newface_ms_headcount = cohort.youth_newfaces.where(id: self.enrollment_ids).length
        self.newface_hs_headcount = cohort.adult_newfaces.where(id: self.enrollment_ids).length
        #self.highschool_headcount = self.enrollments.where('age >= 18').where(id: self.cohort_ids).length
        #self.newface_ms_headcount = self.enrollments.where('id in (?)', self.cohort.youth_newfaces.pluck(:id)).length
        #self.newface_hs_headcount = self.enrollments.where('id in (?)', self.cohort.adult_newfaces.pluck(:id)).length
        
        #age:numeric gender_m:boolean gender_f:boolean gender_o:boolean gender_n:boolean race_wh:boolean race_bl:boolean race_in:boolean race_as:boolean race_hw:boolean race_or:boolean race_no:boolean race_es:boolean lgbt:boolean preg_par:boolean
        
        
        #errors[:base] << 'Something went wrong with enrollment.'
      end
    end
  end

  def receipt_check
    if receipt.attached?
      if receipt.blob.byte_size > 100000000
#        receipt.purge <- not needed with rails 6
        errors[:base] << 'File attachment too big'
      end
    end
  end
  
#  private
  
#  def uniqueness_of_sessions
#    errors.add(:happened_on, 'must be unique') if coho_down_attends.map(&:happened_on).uniq.size != coho_down_attends.size
#  end
end
