class TriesController < ApplicationController
  def create
    try = params[:guess]
    game = Game.find(params[:game_id])
    game.guess(try)
    if game.update(game_params)
      redirect_to game
    else
      redirect_to game, notice: game.errors[:tries]
    end
  end

  private

  def game_params
    params.permit(:tries, :lives)
  end
end
