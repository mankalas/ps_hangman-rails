class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @secret_word = show_secret_word(@game)
  end

  def new
    @game = Game.new(secret: WordPicker.new.pick)
    @game.save
    redirect_to games_path
  end

  private

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
