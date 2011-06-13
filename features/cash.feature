Feature: Cash
  As a programmer
  I want a DSL for action caching
  So that I can easily manage action caching inside a large application

  Scenario: Cash actions in a controller for the default TTL
    When I tell Wallet to `cash` an action on a controller
    Then that action on that controller should cache for the default TTL

  Scenario: Cash every configured action in a controller for a specific TTL
    When I tell Wallet to `cash` any configured actions on a controller for a specific amount of time
    Then any configured actions on that controller should cache for that amount of time

  Scenario: Cash a single action in a controller for a spefic amount of time 
    When I tell Wallet to `cash` all configured actions in a controller for 20 minutes
    And I tell Wallet to `cash` the `index` action for 30 minutes
    Then all configured actions except for index on that controller should cache for 20 minutes
    And the `index` action on that controller should cache for 30 minutes
