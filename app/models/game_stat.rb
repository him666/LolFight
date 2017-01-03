class GameStat < ApplicationRecord
  belongs_to :ProPlayer
  validates :ProPlayer, presence: true
end
