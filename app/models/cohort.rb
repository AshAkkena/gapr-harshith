class Cohort < ApplicationRecord
  belongs_to :provider
  has_paper_trail
  validates :name, presence: true
  validates :curriculum_choice, presence: true
  validates :intended_start, presence: true
  validates :intended_finish, presence: true, after_date: :intended_start
  validates :intended_setting, presence: true
  validates :intended_session_count, numericality: { greater_than: 0 }
  validates :intended_session_duration_minute, numericality: { greater_than: 0 }
  validates :intended_participants_ms, numericality: { greater_than_or_equal_to: 0 }
  validates :intended_participants_hs, numericality: { greater_than_or_equal_to: 0 }
  validates :healthy_relationship_material_add_curr_entirely, either_or: :healthy_relationship_material_add_curr_adhoc
  validates :adolescent_development_material_add_curr_entirely, either_or: :adolescent_development_material_add_curr_adhoc
  validates :financial_literacy_material_add_curr_entirely, either_or: :financial_literacy_material_add_curr_adhoc
  validates :par_child_comm_material_add_curr_entirely, either_or: :par_child_comm_material_add_curr_adhoc
  validates :edu_career_success_material_add_curr_entirely, either_or: :edu_career_success_material_add_curr_adhoc
  validates :healthy_life_skills_material_add_curr_entirely, either_or: :healthy_life_skills_material_add_curr_adhoc
  has_one :coho_up
  has_one :coho_down
  has_many :session_logs
  has_many :entry_surveys, through: :coho_up
  has_many :exit_surveys, through: :coho_up
  has_many :enrollments
  
  def initiates
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE').joins(:session_logs).uniq
  end 
  def newfaces
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE').where.missing(:session_logs).uniq
  end 
  def graduates
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE and graduate is TRUE').uniq
  end 
  def youth_initiates
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE and age < 18').joins(:session_logs)
  end 
  def youth_newfaces
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE and age < 18').where.missing(:session_logs)
  end 
  def adult_initiates
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE and age >= 18').joins(:session_logs)
  end 
  def adult_newfaces
    #self.cohort.enrollments.where(graduate: true).pluck(:id)
    self.enrollments.where('trashed is not TRUE and age >= 18').where.missing(:session_logs)
  end 
  def earliest_date
    result = Array.new()
    if self.coho_down.present?
      if self.coho_down.coho_down_attends.length > 0
        result.push(self.coho_down.coho_down_attends.order(:happened_on).first[:happened_on])
      end
    end
    if self.session_logs.present?
      result.push(self.session_logs.order(:happened_on).first[:happened_on])
    end
    result.sort.first
  end
  def latest_date
    result = Array.new()
    if self.coho_down.present?
      if self.coho_down.coho_down_attends.length > 0
        result.push(self.coho_down.coho_down_attends.order(:happened_on).last[:happened_on])
      end
    end
    if self.session_logs.present?
      result.push(self.session_logs.order(:happened_on).last[:happened_on])
    end
    result.sort.last
  end
end
