When /^I tell Wallet to `cash` an action on a controller$/ do
  Wallet.open do
    cash :home do
      index
    end
  end
end

Then /^that action on that controller should cache for the default TTL$/ do
  Wallet.home.index.should == Wallet.default_ttl
end

When /^I tell Wallet to `cash` any configured actions on a controller for a specific amount of time$/ do
  Wallet.open do
    cash :home, :for => 27.minutes do
      index
    end
  end
end

Then /^any configured actions on that controller should cache for that amount of time$/ do
  Wallet.home.index.should == 27.minutes
end

When /^I tell Wallet to `cash` all configured actions in a controller for (\d+) minutes$/ do |num|
  Wallet.open do
    cash :home, :for => 20.minutes do
      show
      print
      index 30.minutes
    end
  end
end

When /^I tell Wallet to `cash` the `index` action for (\d+) minutes$/ do |arg1|
end

Then /^all configured actions except for index on that controller should cache for (\d+) minutes$/ do |arg1|
  Wallet.home.show.should == 20.minutes
  Wallet.home.print.should == 20.minutes
end

Then /^the `index` action on that controller should cache for (\d+) minutes$/ do |arg1|
  Wallet.home.index.should == 30.minutes
end
