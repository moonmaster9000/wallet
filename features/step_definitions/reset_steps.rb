Given /^I have configured Wallet$/ do
  Wallet.default_ttl = 100.minutes
end

When /^I reset Wallet$/ do
  Wallet.reset!
end

Then /^Wallet should return to it's default settings$/ do
  Wallet.default_ttl.should == 10.minutes
end
