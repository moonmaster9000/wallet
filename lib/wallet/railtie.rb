require 'rails'

module Wallet
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_eager_load do
        wallet = ::Rails.root.to_s + "/config/wallet.rb" 
        require wallet if File.exists?(wallet)  
      end
    end
  end
end
