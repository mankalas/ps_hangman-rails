class Player < ApplicationRecord
  has_many :plays
  has_many :games, through: :plays

  validates :name,
            presence: true,
            format: { with: /\A.+\z/ }
  validates :color,
            format: { with: /\A\#[0-9a-fA-F]{6}\z/ }
end
