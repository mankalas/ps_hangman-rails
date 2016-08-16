class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @game.errors.add(:base, flash[:notice]) if flash[:notice]
    @secret_word = show_secret_word(@game) # instance variable???
  end

  def new
    @game = Game.new(secret: WordPicker.new.pick)
    @game.save
    redirect_to games_path
  end

  private

  # Helper method in another file???
  def show_secret_word(game)
    game.secret.each_char.map do |char|
      game.tries.include?(char) ? char : '_'
    end.join
  end
end

class WordPicker
  UNIX_WORDS_PATH = '/usr/share/dict/words'
  def pick
    File.read(UNIX_WORDS_PATH).split.sample
  end
end
