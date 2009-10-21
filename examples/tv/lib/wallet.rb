# Author::    Matt Parker  (mailto:moonmaster9000@gmail.com)
# License::   Distributes under the same terms as Ruby

class Wallet
  
  # This error gets thrown whenever you attempt to retreive a TTL
  # for an action that's not in the wallet. 
  class ActionNotCached < Exception
  end

  attr_reader :config #:nodoc:
  attr_reader :default_ttl #:nodoc:

  # Pass in a yaml string to this method that represents your configuration. 
  # Let's assume you have a PagesController with a show action and an index action, 
  # and let's suppose you would like wallet to default your action cache ttl's to 5 hours. 
  # Then your yaml might be formatted like so:
  #   # /path/to/wallet.yml
  #   
  #   default_ttl: 5.hours
  #
  #   pages:
  #     show: 
  #     index: 20.minutes
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
    @default_ttl = (eval(@config["default_ttl"]).to_i || 60) rescue 60
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
      (eval(@config[controller][action]).to_i || @default_ttl) rescue @default_ttl
    else
      @default_ttl
    end
  end

  private
  def stringify_params(*args)
    args.map! {|a| a.to_s}
    return *args
  end

end

ActionController::Base.class_eval do
  before_filter :wallet
  @@action_cached_controllers = {}

  def wallet
    @wallet ||= Wallet.new((File.open(RAILS_ROOT + "/config/wallet.yml") rescue ""))
    controller_class_name = self.class.name 
    controller = controller_class_name.underscore.gsub(/_controller$/, '')

    # if we haven't already setup action caching on this controller
    if @@action_cached_controllers[controller] == nil

      @@action_cached_controllers[controller] = controller
      @wallet.cached_actions(controller).each do |action|
        puts "I'm setting up action caching for #{controller_class_name}::#{action}"
        controller_class_name.constantize.send :caches_action, action.to_sym, :expires_in => @wallet.ttl(controller, action)
      end
    end
  end

end
