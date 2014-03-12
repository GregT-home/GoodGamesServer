@sign-in
Feature: Sign in
  As a someone who wants to play a game, I should be able to sign in
  to the game server.

  Scenario: Unsuccessful signin
    Given a user visits the sign-in page
    When they submit invalid sign-in information
    Then they see an error message

  Scenario: Successful signin
    Given a user visits the sign-in page
      And has an account
      And provides valid sign-in credentials
    Then they see the GoFishy game screen
