Feature: Show secret word
  Scenario Outline: Player sees how many letters there are in the secret word
    Given A game with secret word <secret> exists
    And the Player is on the game's page
    Then he sees <nb_letters> letters to guess

    Examples:
    | secret                    | nb_letters |
    | hello                     |          5 |
    | a                         |          1 |
    | aabbcc                    |          6 |
    | anticonstitutionnellement |         23 |
