# Author::    Matt Parker  (mailto:moonmaster9000@gmail.com)
# License::   Distributes under the same terms as Ruby

class Wallet
  
  class << self
    # Attempts to read and load the configuration file (RAILS_ROOT/config/wallet.yml by default)
    def load_from_config(config_file=nil)
      config_file = RAILS_ROOT + "/config/wallet.yml" unless config_file
      new((File.open(config_file) rescue ""))
    end
  end

  # This error gets thrown whenever you attempt to retreive a TTL
  # for an action that's not in the wallet. 
  class ActionNotCached < StandardError
  end
  
  class YamlError < StandardError; end

  class UnknownController < StandardError
  end

  attr_reader :config #:nodoc:
  attr_reader :default_ttl #:nodoc:

  # Pass in a yaml string to this method that represents your configuration. 
  # Let's assume you have a PagesController with a show action and an index action, 
  # and let's suppose you would like wallet to default your action cache ttl's to 5 hours. 
  # Then your yaml might be formatted like so:
  #   # /path/to/wallet.yml
  #   
  #   default_ttl: 5 hours
  #
  #   pages:
  #     show: 
  #     index: 20 minutes
  #
  # That would result in the following values:
  #   irb> w = Wallet.new File.open("/path/to/wallet.yml")
  #   irb> w.cached? :pages, :show
  #   => true
  #   irb> w.cached? :pages, :index
  #   => true
  #   irb> w.cached? :pages, :new
  #   => false
  #   irb> w.ttl :pages, :show
  #   => 300
  #   irb> w.ttl :pages, :index
  #   => 1200
  #   irb> w.ttl :pages, :new
  #   Wallet::ActionNotCached: You asked for the TTL for the 'new' action in the 'pages' controller, 
  #   but according to our wallet configuration, that action is not cached.
  #       from ./lib/wallet/wallet.rb:54:in `ttl'
  #       from (irb):6
  def initialize(config_yml="")
    yml = YAML.load config_yml rescue nil
    @config = yml || {}
    @default_ttl = @config["default_ttl"] ? convert_time(@config["default_ttl"]) : 60
    @config.delete "default_ttl"
    setup_action_caching
  end

  # Returns true or false based on whether or not a controller action is configured for caching in the wallet
  #   irb> w = Wallet.new "pages:\n  show:"
  #   irb> w.cached? :pages, :show
  #   => true
  def cached?(controller, action)
    controller, action = stringify_params controller, action
    @config.has_key?(controller) && 
      @config[controller].respond_to?(:has_key?) && 
      @config[controller].has_key?(action)
  end

  def cached_actions(controller)
    @config[controller] ? @config[controller].keys : []
  end

  # Returns the value of the ttl for a controller / action. Throws an exception if the controller/action isn't setup
  # for caching. 
  #   irb> w = Wallet.new "pages:\n  show:"
  #   irb> w.cached? :pages, :show
  #   => true
  #   irb> w.ttl :pages, :new
  #   Wallet::ActionNotCached: You asked for the TTL for the 'new' action in the 'pages' controller, 
  #   but according to our wallet configuration, that action is not cached.
  #       from ./lib/wallet/wallet.rb:54:in `ttl'
  #       from (irb):6
  def ttl(controller, action)
    raise ActionNotCached.new("You asked for the TTL for the '#{action}' action in the '#{controller}' controller, but according to our wallet configuration, that action is not cached.") unless cached?(controller, action) 
    controller, action = stringify_params controller, action
    if @config[controller][action]
      convert_time @config[controller][action]
    else
      @default_ttl
    end
  end

  private
  def convert_time(time)
    if !(time =~ /^\ *\d+(?:\ +|\.)(?:hours?|minutes?|days?|seconds?)\ *$/)
      raise YamlError.new(
        "'#{time}' is not a valid time phrase. Valid phrases are a number followed by " +
        "a space followed by 'hours' or 'minutes' or 'days' (or the singular versions of those)."
      )
    else
      time = time.strip.gsub(/\ +/, '.')
      eval time
    end
  end
  
  def stringify_params(*args)
    args.map! {|a| a.to_s}
    return *args
  end

  def setup_action_caching
    @config.each do |controller, actions|
      controller_class = (controller + "_controller").camelize.constantize rescue nil
      if controller_class         
        cached_actions(controller).each do |action|
          controller_class.send :caches_action, action.to_sym, :expires_in => ttl(controller, action)
        end
      end
    end
  end
end
