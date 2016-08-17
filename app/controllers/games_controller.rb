class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @game.errors.add(:base, flash[:notice]) if flash[:notice]
  end

  def new
    @game = Game.new(secret: WordPicker.new.pick)
    @game.save
    redirect_to games_path
  end
end

# Here????
class WordPicker
  UNIX_WORDS_PATH = '/usr/share/dict/words'
  def pick
    File.read(UNIX_WORDS_PATH).split.sample
  end
end
