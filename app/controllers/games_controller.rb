class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new

    if @game.save
      redirect_to @game
    else
      redirect_to games_path, notice: @game.errors
    end
  end
end
