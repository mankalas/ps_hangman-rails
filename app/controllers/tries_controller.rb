class TriesController < ApplicationController
  def create
    try = tries_params
    game = Game.find(params[:game_id])

    game.guess(try)

    if game.update
      redirect_to game
    else
      redirect_to game, notice: game.errors[:tries]
    end
  end

  private

  def tries_params
    params.require(:guess)
  end
end
