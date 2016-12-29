class Tip < ApplicationRecord
  belongs_to :champion
  validates :champion, presence: true
end
