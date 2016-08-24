class TryValidator < ActiveModel::Validator
  def validate(record)
    tries = record.tries
    if tries != nil
      duplicates = tries.each_char.detect do |char|
        tries.count(char) > 1
      end
      record.errors[:tries] << "Already tried '#{duplicates}'" if duplicates
    end
  end
end

module WordPicker
  UNIX_WORDS_PATH = '/usr/share/dict/words'
  def pick_word
    File.read(UNIX_WORDS_PATH).split.sample
  end
end

class Game < ApplicationRecord
  include WordPicker

  validates :secret,
            presence: true,
            format: { with: /\A[a-zA-Z]+\z/ }
  validates :lives,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :tries,
            format: { with: /\A[a-zA-Z]*\z/, message: "input must be a letter" }
  validates_with TryValidator, fields: [:tries]

  has_many :plays
  has_many :players, through: :plays

  def initialize(arguments={})
    super
    self.secret ||= pick_word
  end

  def lost?
    lives <= 0
  end

  def won?
    secret.each_char.all? { |char| tries.include?(char) }
  end

  def secret_word_masked
    secret.each_char.map { |char| tries.include?(char) ? char : nil }
  end

  def guess(try)
    self.tries << try
    if failed_try?(try)
      play = current_play
      play.lives -= 1
      play.save!
      set_next_turn
    end
  end

  def set_next_turn
    cur_play = current_play
    cur_play.active = false
    cur_play.save!

    plays_ordered_by_id = plays.order(:id)
    next_play = plays_ordered_by_id.find { |play| play.id > cur_play.id && play.lives > 0 }
    next_play ||= plays_ordered_by_id.first

    next_play.active = true
    next_play.save!
  end

  def failed_try?(try)
    valid? and not secret.include?(try)
  end

  def guess!(try)
    guess(try)
    save!
  end

  def guesses_already_made?
    tries.length > 0
  end

  def add_player(player_id)
    self.players << Player.find(player_id)
  end

  def set_first_player
    play = plays.take
    play.active = true
    play.save!
  end

  def current_player
    Player.find(current_play.player_id)
  end

  def current_player_name
    current_player.name
  end

  def current_player_color
    current_player.color
  end

  def current_play
    plays.find_by(active: true)
  end

  def current_player_lives
    current_play.lives
  end
end
