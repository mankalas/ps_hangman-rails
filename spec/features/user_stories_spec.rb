feature "1. User creates a game" do
  scenario 'They see and click the new game link' do
    visit games_path
    expect{ click_link 'Create a new game' }.to change{ Game.count }.by(1)
  end
end

feature "2. User sees how many letters there are in the word" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "They see as many underscores as there are letters in the secret word" do
    visit game_path(game)
    expect(page).to have_content(('_' * game.secret.length).chars.join(' '))
  end
end

def submit_letter(letter)
  fill_in 'guess', with: letter
  click_button 'Guess'
end

feature "3. User submits one letter" do
  fixtures :games
  let(:game) { games(:game) }
  let(:good_letter) { 'e' }

  before do
    visit game_path(game)
  end

  scenario "The letter is in the word" do
    submit_letter(good_letter)
    expect(page).to have_content('e_e_____'.chars.join(' '))
  end

  scenario "The letter is not in the word" do
    bad_letter = 'x'
    submit_letter(bad_letter)
    expect(page).to have_content(('_' * game.secret.length).chars.join(' '))
    expect(page).to have_content("You've already tried #{bad_letter}")
  end

  scenario "The letter has already been guessed" do
    2.times { submit_letter(good_letter) }
    expect(page).to have_content("Already tried '#{good_letter}'")
  end
end

feature "4. Bad input gracefully handled" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "The user submit bad input" do
    visit game_path(game)
    submit_letter('!')
    expect(page).to have_content('input must be a letter')
  end
end

feature "5. User sees good letters" do
  # Already tested in 3.
end

feature "6. User sees bad letters" do
  # Already tested in 3.
end

feature "7. User sees how many lives remaining" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "6 lives left in a new game" do
    visit game_path(game)
    expect(page).to have_content("6 lives remaining")
  end
end

feature "8. Life deduction upon bad guess" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "User makes a wrong guess" do
    visit game_path(game)
    expect(page).to have_content("6 lives remaining")
    submit_letter('x')
    expect(page).to have_content("5 lives remaining")
  end
end

feature "9. Game ends with a win" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "The user guesses all the good letters" do
    visit game_path(game)
    game.secret.chars.each { |char| submit_letter(char) }
    expect(page).to have_content("Congrats!")
  end
end

feature "10. Game ends with a lose" do
  fixtures :games
  let(:game) { games(:game) }

  scenario "The user loses all his lives" do
    visit game_path(game)
    'qwryui'.chars.each { |char| submit_letter(char) }
    expect(page).to have_content("You've lost the game")
  end
end
