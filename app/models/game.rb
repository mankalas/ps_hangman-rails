class Game < ApplicationRecord
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
    self.secret ||= pick_word
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

  def guess(try)
    self.tries << try

    if valid?
      self.lives -= 1 unless secret.include?(try)
    end
  end

  def guesses_already_made?
    tries.length > 0
  end

  def pick_word
    File.read('/usr/share/dict/words').split.sample
  end
end
