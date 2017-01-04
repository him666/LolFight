class ProPlayer < ApplicationRecord
  has_many :game_stats, inverse_of: :ProPlayer
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.average(id,column)
    ProPlayer.find(id).game_stats.average(column).to_i
  end
end
