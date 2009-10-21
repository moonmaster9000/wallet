class ChannelsController < ApplicationController
 
  caches_action :cartoon_network, :expires_in => 10.seconds 

  def cartoon_network
  end

  def current
  end

end
