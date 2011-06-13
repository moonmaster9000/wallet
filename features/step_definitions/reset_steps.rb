Given /^I have configured Wallet$/ do
  Wallet.default_ttl = 100.minutes

  Wallet.open do
    cash :home do
      index
    end
  end

  Wallet.default_ttl.should == 100.minutes
  Wallet.home.index.should == Wallet.default_ttl
end

When /^I reset Wallet$/ do
  Wallet.reset!
end

Then /^Wallet should return to it's default settings$/ do
  Wallet.default_ttl.should == 10.minutes
  Wallet.home.should be_nil
end
