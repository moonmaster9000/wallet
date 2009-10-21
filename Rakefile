require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "wallet"
    gemspec.summary     = "Centralized YAML configuration for action caching."
    gemspec.description = "Wallet is a rails gem that allows you to manage all of" + 
                          " your action caching configuration in a single yaml file. " + 
                          "Supports TTLs."
    gemspec.email       = "moonmaster9000@gmail.com"
    gemspec.files       = FileList['lib/**/*.rb', 'README.rdoc']
    gemspec.homepage    = "http://github.com/moonmaster9000/wallet"
    gemspec.authors     = ["Matt Parker"]
    gemspec.add_dependency('rails', '>= 2.3.3')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
