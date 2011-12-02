require './lib/aria2/server'
require './lib/aria2/methods'

class Aria2
  class << self
    def this_session
      session["sessionId"]
    end
  end
end
