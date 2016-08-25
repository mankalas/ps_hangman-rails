class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new
    params[:game][:player_ids].each do |player_id|
      @game.add_player(player_id)
    end
    if @game.save
      @game.set_first_player!
      redirect_to @game
    else
      redirect_to games_path, notice: @game.errors
    end
  end
end
