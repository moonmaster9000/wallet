module Wallet
  extend self
  attr_accessor :default_ttl

  def default_ttl
    @default_ttl ||= 10.minutes
  end

  def reset!
    @default_ttl = nil
  end
end
