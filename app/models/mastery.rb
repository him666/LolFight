class Mastery < ApplicationRecord
  validates :game_num, uniqueness: true
end
