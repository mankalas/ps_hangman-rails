class TriesController < ApplicationController
  def new
    try = params[:guess]
    game = Game.find(params[:game_id])
    if !(try =~ /^[[:alpha:]]$/)
      redirect_to game, notice: "Bad input: '#{try}'"
    else
      if game.tries.include?(try)
        redirect_to game, notice: "Already tried #{try}"
      else
        game.tries << try
        game.lives -= 1 unless game.secret.include?(try)
        game.update(game_params)
        redirect_to game
      end
    end
  end

  private

  def game_params
    params.permit(:tries, :lives)
  end
end
