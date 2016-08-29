Feature: The Player submits some input
  Scenario Outline: The Player submits a correct guess
    Given A game with secret word <secret> exists
    And the Player is on the game's page
    And the Player has already tried <tries>
    When he guesses <guess>
    Then he sees the secret word as <revealed_secret>
    And he sees <guess> as already tried
    And he has full lives
    Examples:
    | secret | tries | guess | revealed_secret |
    | ab     |       | a     | a_              |
    | aba    |       | a     | a_a             |
    | bab    |       | a     | _a_             |
    | babc   | b     | a     | bab_            |
    | abcd   | bc    | a     | abc_            |

  Scenario Outline: The player submits a incorrect guess
    Given A game with secret word <secret> exists
    And the Player is on the game's page
    And the Player has already tried <tries>
    When he guesses <guess>
    Then he sees the secret word as <revealed_secret>
    And he sees <guess> as already tried
    And he has <lives> lives left
    Examples:
    | secret | tries | guess | revealed_secret | lives |
    | ab     | a     | c     | a_              |     5 |
    | aba    | a     | c     | a_a             |     5 |
    | bab    | a     | c     | _a_             |     5 |
    | ab     |       | c     | __              |     5 |

  Scenario Outline: The player sumbits a bad input
    Given The Player is on any game's page
    When he guesses <guess>
    Then he sees an error about bad input
    Examples:
    | guess |
    | 1     |
    | !     |
    | ?     |
    | #     |
