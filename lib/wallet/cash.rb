module Wallet
  module Cash
    extend ActiveSupport::Concern

    module ClassMethods
      def cash!
        controller_name = self.to_s.underscore.gsub('_controller', '').to_sym
        if controller_cache_config = Wallet.send(controller_name)
          controller_cache_config.actions.each do |action_name, ttl|
            caches_action action_name, :expires_in => ttl
          end
        end
      end
    end
  end
end
