module DownloadManager
  class << self
    def add down
      update_status down
      
      return false unless down.status == "error" or down.status == "new"
      
      down.options["dir"] = dir_for down
      begin
        down.gid             = Aria2.add down.uri, down.options
        down.info["session"] = Aria2.this_session
      rescue
        return false
      else
        down.status     = "added"
        down.started_at = Time.now
        down.save
      end
    end
    
    def add_all
      Download.to_add.find_each { |down| add down }
    end
    
    def dir_for down
      #FIXME: use conf file to generate better dirs
      down.options["dir"] or "/tmp/downloads"
    end
    
    def has_valid_gid? down
      not (down.gid.nil? or down.info["session"] != Aria2.this_session)
    rescue
      false
    end
    
    def status down, keys=[]
      Aria2.status(down.gid, keys) rescue nil
    end
    
    def update_status down
      return unless has_valid_gid? down
      
      begin
        keys = ["status", "errorCode", "files"]
        down.status, error, files = Aria2.status(down.gid, keys).values_at(*keys)
      rescue
        return
      end
      
      down.error = nil
      
      case down.status
      when "complete"
        down.gid          = nil
        down.info         = {}
        down.files        = files.map { |f| f["path"] }
        down.completed_at = Time.now
      when "error"
        down.error = "ErrorCode: #{error}"
      end
          
      down.save
    end
    
    def update_status_all
      Download.to_check.find_each { |down| update_status down }
    end
    
    def remove_files down
      FileUtils.rm_rf down.files
      down.files_removed = true
      down.removed = true
      down.save
    end
  end
end
