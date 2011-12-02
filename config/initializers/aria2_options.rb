require 'parseconfig'

class Aria2Config
  # This class provides easy access to config options in 'config/aria2.conf' options
  class << self
    def config
      @@config ||= ParseConfig.new "config/aria2.conf"
    end
    
    def get name, default=nil
      name = name.to_s.sub('_','-')
      if config.params.keys.include? name
        config.get_value name
      else
        default
      end
    end
  end
end
