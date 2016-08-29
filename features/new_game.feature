Feature: New game
  Scenario: Player creates a new game
    Given Player is on the index page
    When he clicks on the new game link
    Then a new game is created
    And the game's page is shown
