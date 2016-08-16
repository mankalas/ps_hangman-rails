class TriesController < ApplicationController
  def edit
    try = params[:try][:guess]
    game = Game.find(params[:id])
    if not game.tries.include?(try)
      game.tries << try
      game.lives -= 1 unless game.secret.include?(try)
      game.update(game_params)
    end
    # Nicer way to do it?
    redirect_to game, notice: "Already tried #{try}"
  end

  private

  def game_params
    params.permit(:tries)
  end
end
