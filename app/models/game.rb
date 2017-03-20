class Game < ApplicationRecord
  # Associations
  has_many :plays
  has_many :players, through: :plays

  # Validations
  validates :secret,
            presence: true,
            format: { with: /\A[a-zA-Z]+\z/ }

  validates :lives,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  validates :tries,
            format: { with: /\A[a-zA-Z]*\z/, message: "input must be a letter" }
  validate :check_duplicates

  def check_duplicates
    if tries != nil
      duplicates = tries.each_char.detect { |char| tries.count(char) > 1 }
      errors[:tries] << "Already tried '#{duplicates}'" if duplicates
    end
  end

  # Callbacks
  before_validation :init_secret, on: :create

  def init_secret
    self.secret ||= 'horseshit'
  end

  #
  def lost?
    lives <= 0
  end

  def won?
    (secret.chars - tries.chars).empty?
  end

  def secret_word_masked
    secret.each_char.map { |char| tries.include?(char) ? char : nil }
  end

  def failed_try?(try)
    # Bad input is not a failed try: it's a invalid try.
    valid? and not secret.include?(try)
  end

  def set_next_turn
    current_play.set_active!(false)

    plays_ordered_by_id = plays.order(:id)
    first_play = plays_ordered_by_id.first
    next_play = plays_ordered_by_id.find(&method(:next_valid?)) || first_play

    next_play.set_active!(true)
  end

  def guess(try)
    self.tries << try

    if failed_try?(try)
      current_play.lose_a_life!
      set_next_turn
    end
  end

  def guesses_already_made?
    tries.length > 0
  end

  def add_player(player_id)
    self.players << Player.find(player_id)
  end

  def set_first_player!
    plays.take.set_active!(true)
  end

  def current_player
    Player.find(current_play.player_id)
  end

  def current_play
    plays.find_by(active: true)
  end
end
