module GamesHelper
  def format_masked_word(mask)
    mask.map { |char| char || '_' }.join(' ')
  end

  def format_tries(game)
    game.tries.chars.join(', ')
  end

  def show_lives_image(game)
    image_tag "hang#{7 - game.lives}"
  end

  def show_lives_sentence(game)
    "#{pluralize(game.lives, 'life')} remaining."
  end

  def show_status(game)
    if game.won?
      "Won"
    elsif game.lost?
      "Lost"
    else
      "In progress"
    end
  end

  def render_game_status(game)
    if game.won?
      render partial: 'won'
    elsif game.lost?
      render partial: 'lost'
    else
      render partial: 'in_progress'
    end
  end
end
