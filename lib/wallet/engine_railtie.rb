require 'rails'

module Wallet
  module Railtie 
    def self.included(base)
      base.config.before_initialize do
        wallet = "#{base.root}/config/wallet.rb"
        require wallet if File.exists?(wallet)
      end
    end
  end
end
