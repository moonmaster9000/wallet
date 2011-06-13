Given /^I have setup Wallet to cache several actions in a controller$/ do
  class HomeController
    def self.caches_action(action_name, options)
    end
  end

  Wallet.open do
    cash :home do
      index 2.minutes
    end
  end
end

When /^I mix Wallet::Cash into that controller$/ do
  class HomeController
    include Wallet::Cash
  end
end

When /^I call the `cash!` method on it$/ do
  @call = proc { HomeController.cash! }
end

Then /^it should tell Rails to cache the appropriate actions$/ do
  HomeController.should_receive(:caches_action).with(:index, :expires_in => 2.minutes).and_return nil
  @call.call
end
