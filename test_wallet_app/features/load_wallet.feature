Feature: Load Wallet
  Wallet should auto load on app boot
  
  Scenario: Wallet should be loaded on boot before the controllers load
    Given I have configured Wallet
    When the app boots
    Then controllers should have action caching set up
