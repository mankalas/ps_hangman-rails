class Game < ApplicationRecord
  def lost?
    lives <= 0
  end

  def won?
    if secret
      secret.each_char.all? do |char|
        tries.include?(char)
      end
    end
  end

  def show_secret_word
    secret.each_char.map do |char|
      tries.include?(char) ? char : '_'
    end.join(' ')
  end
end
