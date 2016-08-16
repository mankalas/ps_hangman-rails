class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
    @game.save
    redirect_to @game
  end

end
