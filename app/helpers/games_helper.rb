module GamesHelper
  def format_masked_word(mask)
    mask.map { |char| char ? char : '_' }.join(' ')
  end

  def format_tries(tries)
    tries.chars.join(', ')
  end
end
