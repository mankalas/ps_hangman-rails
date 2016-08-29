Given(/^Player is on the index page$/) do
  visit games_path
end

When(/^he clicks on the new game link$/) do
  click_link 'Create a new game'
end

Then(/^a new game is created$/) do
  @game = Game.last
  Game.count == 1
end

Then(/^the game's page is shown$/) do
  expect(page).to have_title("Game ##{@game.id}")
end

Given(/^A game with secret word (\w+) exists$/) do |secret|
  @game = Game.new(secret: secret)
  @game.save!
end

Given(/^the Player is on the game's page$/) do
  visit game_path(@game)
end

Given(/^the Player has already tried (\w*)$/) do |tries|
  @game.tries = tries
  @game.save
end

Then(/^he sees (\d+) letters to guess$/) do |nb_letters|
  expect(page).to have_content(('_' * nb_letters.to_i).chars.join(' '))
end

When(/^he guesses (.+)$/) do |guess|
  @guess = guess
  fill_in 'guess', with: guess
  click_button 'Guess'
end

Then(/^he sees the secret word as (\w+)$/) do |revealed_secret|
  expect(page).to have_content(revealed_secret.chars.join(' '))
end

Then(/^he sees (\w) as already tried$/) do |guess|
  expect(page).to have_content("You've already tried #{(@game.tries + guess).chars.join(', ')}")
end

Then(/^he has full lives$/) do
  expect(page).to have_content("6 lives remaining")
end

Then(/^he has (\d+) lives left$/) do |lives|
  expect(page).to have_content("#{lives} #{'life'.pluralize(lives)} remaining")
end

Given(/^The Player is on any game's page$/) do
  game = Game.new
  game.save
  visit game_path(game)
end

Then(/^he sees an error about bad input$/) do
  expect(page).to have_css('.flashnotice')
end
