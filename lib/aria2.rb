require './lib/aria2/server'
require './lib/aria2/methods'

class Aria2
  class << self
    def this_session
      session["sessionId"]
    end
    
    def limit
      change_global_options Aria2Config.get(:limit_options, {})
    end

    def unlimit
      change_global_options Aria2Config.get(:unlimit_options, {})
    end
  end
end
