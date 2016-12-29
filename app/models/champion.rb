class Champion < ApplicationRecord
  has_many :spells, inverse_of: :champion
  has_many :tips, inverse_of: :champion
  validates :game_num, uniqueness: true

end
