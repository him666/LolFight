class Rune < ApplicationRecord
  validates :game_num, uniqueness: true
end
