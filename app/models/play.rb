class Play < ApplicationRecord
  belongs_to :game
  belongs_to :player

  def lose_a_life!
    self.lives -= 1
    save!
  end

  def next_valid?(previous_play_id)
    id > previous_play_id and lives > 0
  end

  def set_active!(active_state)
    self.active = active_state
    save!
  end
end
