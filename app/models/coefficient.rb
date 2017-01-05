class Coefficient < ApplicationRecord
  belongs_to :spell
  validates :spell, presence: true
end
