@welcome
Feature: Welcome Page

As a someone who wants to play an on-line game, I go to a game
page to find games to play.

  Scenario: First Impression
    Given a user visits the home page
    Then they should see a descriptive page
    Then they should see a navigation bar
    And it contains a Home Link
      And a Sign in link
      And a Help link
      And does not contain a Play link
    Then they should see a welcome message
      And a choice to Sign up
      And a choice to Sign in

