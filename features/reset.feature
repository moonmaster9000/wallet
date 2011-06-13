Feature: Reset Wallet
  As a programmer
  I want a way to reset the Wallet configuration
  So that I can easily test it

  Scenario: resetting the Wallet back to it's factory settings
    Given I have configured Wallet
    When I reset Wallet
    Then Wallet should return to it's default settings
