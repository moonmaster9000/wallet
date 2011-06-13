class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :hi

  include Wallet::Cash
  cash!

  before_filter :after_cache_happens

  private
  def hi
    puts "hi before filter!"
  end

  def after_cache_happens
    puts "I run after a cache lookup!"
  end
end
