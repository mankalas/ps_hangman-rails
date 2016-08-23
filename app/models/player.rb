class Player < ApplicationRecord
  has_many :plays
  has_many :games, through: :plays
end
