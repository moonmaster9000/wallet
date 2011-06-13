Feature: Controller DSL
  As a programmer
  I want to be able to mix Wallet into my controller
  so that I can cache actions on that controller

  Scenario: Telling a controller to cache actions
    Given I have setup Wallet to cache several actions in a controller
    When I mix Wallet::Cash into that controller
    And I call the `cash!` method on it
    Then it should tell Rails to cache the appropriate actions
