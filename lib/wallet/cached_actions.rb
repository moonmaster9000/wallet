module Wallet
  module Configuration
    class CachedActions
      attr_reader :actions

      def initialize(options={})
        @actions = {}
        @default_ttl = options[:default_ttl] || Wallet.default_ttl
      end

      def method_missing(action_name, *args, &block)
        action = action_name.to_sym
        @actions[action] = args.first.to_i if args.first
        @actions[action] ||= @default_ttl
      end
    end
  end
end
