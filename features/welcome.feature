@welcome
Feature: Welcome Page

As a someone who wants to play an on-line game, I go to a game
page to find games to play.

  Scenario: First Impression
    Given a user visits the home page
    Then they should see a descriptive page
    And be able to sign-in
