module Wallet
  module Configuration
    extend self

    def cash(controller, options={}, &block)
      controllers[controller.to_sym] ||= Wallet::Configuration::CachedActions.new(
        :default_ttl => (options[:for] || Wallet.default_ttl)
      )
      controllers[controller.to_sym].instance_eval &block
    end
    
    def controllers
      @controllers ||= {}
    end

    def reset!
      @controllers = {}
    end
  end
end
