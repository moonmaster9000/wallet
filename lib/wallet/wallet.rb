module Wallet
  extend self
  attr_accessor :default_ttl

  def default_ttl
    @default_ttl ||= 10.minutes
  end

  def reset!
    @default_ttl = nil
    Configuration.reset!
  end

  def open(&block)
    Configuration.instance_eval &block
  end

  def method_missing(method_name, *args, &block)
    Configuration.controllers[method_name.to_sym]
  end
end
