class SumSpell < ApplicationRecord
  validates :game_num, uniqueness: true
end
