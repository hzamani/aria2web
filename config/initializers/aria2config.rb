require 'parseconfig'

module Aria2Config
  # This module provides easy access to config options in 'config/aria2.conf' options
  class << self
    def config
      @@config ||= ParseConfig.new "config/aria2.conf"
    end
    
    def fetch name, default=nil
      name = name.to_s.gsub('_','-')
      config.params.fetch name, default
    rescue
      default
    end
  end
end
