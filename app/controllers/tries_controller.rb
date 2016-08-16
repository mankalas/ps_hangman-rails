class TriesController < ApplicationController
  def new
    try = params[:guess]
    game = Game.find(params[:game_id])
    if not game.tries.include?(try)
      game.tries << try
      game.lives -= 1 unless game.secret.include?(try)
      game.update(game_params)
      redirect_to game
    else
      redirect_to game, notice: "Already tried #{try}"
    end
  end

  private

  def game_params
    params.permit(:tries, :lives)
  end
end
