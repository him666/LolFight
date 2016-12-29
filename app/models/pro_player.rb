class ProPlayer < ApplicationRecord
  has_many :game_stats
  validates :game_num, presence: true
end
