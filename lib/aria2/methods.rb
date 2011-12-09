module Aria2
  class << self
    # These are default aria2c rpc methods
    # for more info look at #rpc section on aria2c manpage
    
    def addUri uris, options={}
      server.call "aria2.addUri", [*uris], options
    end
    alias :add :addUri

    def tellStatus gid, keys=[]
      server.call "aria2.tellStatus", gid, keys
    end
    alias :status :tellStatus

    def remove gid
      server.call "aria2.remove", gid
    end

    def pause gid
      server.call "aria2.pause", gid
    end

    def pauseAll
      server.call "aria2.pauseAll"
    end
    alias :pause_all :pauseAll

    def unpause gid
      server.call "aria2.unpause", gid
    end
    alias :resume :unpause

    def unpauseAll
      server.call "aria2.unpauseAll"
    end
    alias :resume_all :unpauseAll

    def getUris gid
      server.call "aria2.getUris", gid
    end
    alias :uris :getUris

    def getFiles gid
      server.call "aria2.getFiles", gid
    end
    alias :files :getFiles

    def getPeers gid
      server.call "aria2.getPeers", gid
    end
    alias :peers :getPeers

    def getServers gid
      server.call "aria2.getServers", gid
    end
    alias :servers :getServers

    def tellActive keys=[]
      server.call "aria2.tellActive", keys
    end
    alias :active :tellActive

    def tellWaiting offset, num, keys=[]
      server.call "aria2.tellWaiting", offset, num, keys
    end
    alias :waiting :tellWaiting

    def tellStopped offset, num, keys=[]
      server.call "aria2.tellStopped", offset, num, keys
    end
    alias :stopped :tellStopped

    def changePosition gid, pos, how
      server.call "aria2.changePosition", gid, pos, how
    end
    alias :change_pos :changePosition


    def getOption gid
      server.call "aria2.getOption", gid
    end
    alias :options :getOption

    def changeOption gid, options
      server.call "aria2.changeOption", gid, options
    end
    alias :change_options :changeOption

    def getGlobalOption
      server.call "aria2.getGlobalOption"
    end
    alias :global_options :getGlobalOption

    def changeGlobalOption options
      server.call "aria2.changeGlobalOption", options
    end
    alias :change_global_options :changeGlobalOption

    def getGlobalStat
      server.call "aria2.getGlobalStat"
    end
    alias :global_status :getGlobalStat

    def purgeDownloadResult
      server.call "aria2.purgeDownloadResult"
    end
    alias :clean :purgeDownloadResult

    def removeDownloadResult gid
      server.call "aria2.removeDownloadResult", gid
    end
    alias :remove_result :removeDownloadResult

    def getVersion
      server.call "aria2.getVersion"
    end
    alias :version :getVersion

    def getSessionInfo
      server.call "aria2.getSessionInfo"
    end
    alias :session :getSessionInfo

    def shutdown
      server.call "aria2.shutdown"
    end
  end
end
