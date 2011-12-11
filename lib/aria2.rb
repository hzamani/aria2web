require "#{Rails.root}/lib/aria2/server"
require "#{Rails.root}/lib/aria2/methods"

module Aria2
  class << self
    def this_session
      session["sessionId"]
    end
    
    def limit
      change_global_options Aria2Config.fetch(:limit_options, {})
    end

    def unlimit
      change_global_options Aria2Config.fetch(:unlimit_options, {})
    end
  end
end
