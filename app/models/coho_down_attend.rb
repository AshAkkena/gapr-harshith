class CohoDownAttend < ApplicationRecord
  belongs_to :coho_down
  has_one :cohort, through: :coho_down
  has_paper_trail
  validates_presence_of :coho_down
  validates_presence_of :happened_on
  validates :middleschool_headcount, numericality: { greater_than_or_equal_to: 0 }
  validates :highschool_headcount, numericality: { greater_than_or_equal_to: 0 }
  validates :newface_ms_headcount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.middleschool_headcount } }
  validates :newface_hs_headcount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: Proc.new {|t| t.highschool_headcount } }
end
