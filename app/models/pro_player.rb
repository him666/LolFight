class ProPlayer < ApplicationRecord
  has_many :game_stats, inverse_of: :ProPlayer
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.cs_prom(id)
    pro = ProPlayer.find(id)
    cs_num = 0
    pro.game_stats.each do |game|
      cs_num += game.minions
    end
    cs_num/20
  end

  def self.k_prom(id)
    pro = ProPlayer.find(id)
    k_prom = 0
    pro.game_stats.each do |game|
      k_prom += game.kills
    end
    k_prom/20
  end

  def self.d_prom(id)
    pro = ProPlayer.find(id)
    d_prom = 0
    pro.game_stats.each do |game|
      d_prom += game.deaths
    end
    d_prom/20
  end

  def self.a_prom(id)
    pro = ProPlayer.find(id)
    a_prom = 0
    pro.game_stats.each do |game|
      a_prom += game.assists
    end
    a_prom/20
  end

  def self.w_prom(id)
    pro = ProPlayer.find(id)
    w_prom = 0
    pro.game_stats.each do |game|
      w_prom += game.wards
    end
    w_prom/20
  end

end
