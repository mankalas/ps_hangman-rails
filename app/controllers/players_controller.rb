class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def create
    @player = Player.new(player_params)

    if @player.save(player_params)
      redirect_to players_path
    else
      redirect_to players_path, notice: @player.errors
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :color)
  end
end
