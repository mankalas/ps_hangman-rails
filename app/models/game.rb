class Game < ApplicationRecord
  def lost?
    lives <= 0
  end
end
