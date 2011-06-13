Given /^I have not configured Wallet$/ do
end

Then /^the default TTL should be (\d+) minutes$/ do |num|
  Wallet.default_ttl.should == num.to_i.minutes
end

When /^I set the default TTL to (\d+) minutes$/ do |num|
  Wallet.default_ttl = num.to_i.minutes
end

Then /^all cache TTL's should default to (\d+) minutes$/ do |num|
  Wallet.default_ttl.should == num.to_i.minutes
end
