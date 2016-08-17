class TryValidator < ActiveModel::Validator
  def validate(record)
    tries = record.tries
    duplicates = tries.each_char.detect do |char|
      tries.count(char) > 1
    end
    record.errors[:tries] << "Already tried '#{duplicates}'" if duplicates
  end
end

class Game < ApplicationRecord
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

  def lost?
    lives <= 0
  end

  def won?
    secret.each_char.all? do |char|
      tries.include?(char)
    end
  end

  def show_secret_word
    secret.each_char.map do |char|
      tries.include?(char) ? char : '_'
    end.join(' ')
  end

  def guess(try)
    self.tries << try
    if valid?
      self.lives -= 1 unless secret.include?(try)
    end
  end
end
