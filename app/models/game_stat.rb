class GameStat < ApplicationRecord
  belongs_to :ProPlayer
  validates :ProPlayer, presence: true
  def self.average(champion, column)
    GameStat.where(champion: champion).average(column).to_i
  end
  def self.max(champion, column)
    GameStat.where(champion: champion).maximum(column).to_i
  end
end
