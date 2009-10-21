require 'wallet/wallet'
require 'wallet/action_controller'
Wallet.new((File.open(RAILS_ROOT + "/config/wallet.yml") rescue "")) if defined?(RAILS_ROOT)
