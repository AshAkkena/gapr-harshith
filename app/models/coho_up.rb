class CohoUp < ApplicationRecord
  belongs_to :cohort
  has_one :provider, through: :cohort
  
  has_paper_trail
  validates :cohort_id, presence: true
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
  has_many :entry_surveys, primary_key: :magic_code, foreign_key: :magic, dependent: :nullify
  has_many :exit_surveys, primary_key: :magic_code, foreign_key: :magic, dependent: :nullify
end
