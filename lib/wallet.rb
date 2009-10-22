require 'wallet/wallet'
Wallet.new((File.open(RAILS_ROOT + "/config/wallet.yml") rescue "")) if defined?(RAILS_ROOT)
