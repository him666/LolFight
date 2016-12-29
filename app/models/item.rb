class Item < ApplicationRecord
  validates :game_num, uniqueness: true
end
