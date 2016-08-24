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

  has_and_belongs_to_many :players

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
      self.lives -= 1
      self.current_player_index = (current_player_index + 1) % players.length
    end
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
    player = Player.find(player_id)
    self.players << player
  end

  def current_player
    players.all[current_player_index]
  end

  def current_player_name
    current_player.name
  end

  def current_player_color
    current_player.color
  end
end
