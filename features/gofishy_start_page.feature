@start
Feature: GoFishy Start Page

As a GoFishy player, I come to the starting page to play a game.

  Scenario: A player on the GoFishy Play Page

    Given a GoFishy Player
      When they sign-in
      Then they will see the GoFishy Page
        And the History Area with messages about the Last Round
        And the Action Area that shows who to ask for what cards
	And the Card Area showing their cards
	And the Books Area showing their books
	And the Status Area showing whose turn it is
	And the Status Area showing how many cards the pond has
	And the Status Area showing the status of players

