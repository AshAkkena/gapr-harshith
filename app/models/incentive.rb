class Incentive < ApplicationRecord
  validates_uniqueness_of :fingerprint, scope: %i[period species variety]
end
