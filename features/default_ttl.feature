Feature: 
  As a programmer
  I want a configurable TTL default
  So that I can provide a default TTL for my action cache

  Scenario: TTL defaults to 10 minutes
    Given I have not configured Wallet
    Then the default TTL should be 10 minutes

  Scenario: Change the default TTL
    When I set the default TTL to 20 minutes
    Then all cache TTL's should default to 20 minutes
