require 'test_wallet_engine'
require 'rails'

module TestWalletEngine
  class Engine < ::Rails::Engine
    include Wallet::Railtie
  end
end
