class ExitSurvey < ApplicationRecord
  belongs_to :coho_up, primary_key: :magic_code, foreign_key: :magic, optional: true
  has_paper_trail
end
