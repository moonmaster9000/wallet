require 'rails'

module Wallet
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_initialize do
        wallet = ::Rails.root.to_s + "/config/wallet.rb" 
        require wallet if File.exists?(wallet)  
      end
    end
  end
end
