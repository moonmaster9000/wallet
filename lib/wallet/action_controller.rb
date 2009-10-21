#ActionController::Base.class_eval do
#  before_filter :wallet
#  @@action_cached_controllers = {}
#
#  def wallet
#    @wallet ||= Wallet.new((File.open(RAILS_ROOT + "/config/wallet.yml") rescue ""))
#    controller_class_name = self.class.name 
#    controller = controller_class_name.underscore.gsub(/_controller$/, '')
#
#    # if we haven't already setup action caching on this controller
#    if @@action_cached_controllers[controller] == nil
#      @@action_cached_controllers[controller] = controller
#      @wallet.cached_actions(controller).each do |action|
#        controller_class_name.constantize.send :caches_action, action.to_sym, :expires_in => @wallet.ttl(controller, action)
#      end
#    end
#  end
#
#end if defined?(ActionController::Base)
