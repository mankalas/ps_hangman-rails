class Game < ApplicationRecord
  def lost?
    lives <= 0
  end

  def show_secret_word
    secret.each_char.map do |char|
      tries.include?(char) ? char : '_'
    end.join(' ')
  end
end
