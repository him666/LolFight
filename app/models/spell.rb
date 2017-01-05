class Spell < ApplicationRecord
  belongs_to :champion
  validates :champion, presence: true
  has_many :coefficients, inverse_of: :spell
end
