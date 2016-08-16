class TriesController < ApplicationController
  def edit
    try = params[:try][:guess]
    game = Game.find(params[:id])
    if not games.tries.include?(try)
      game.tries << try
      game.lives -= 1 unless game.secret.include?(try)
      game.update(game_params)
    end
    redirect_to game
  end

  private

  def game_params
    params.permit(:tries)
  end
end
