class Download < ActiveRecord::Base
  attr_accessible :uri
  
  serialize :options
  serialize :info
  
  scope :to_add,   where("status = 'new'").order("created_at")
  scope :to_check, where("status = 'added' or status = 'active'")
  
  before_create do
    self[:status]  = 'new'
    self[:options] = {}
    self[:info]    = {}
  end
  
  def add
    update_status
    if ["error", "new"].include? status
      begin
        set_dir
        self.gid        = Aria2.add uri, options
        self.status     = "added"
        info["session"] = Aria2.this_session
        res = save
      rescue
        res = false
      end
    end
    res
  end
  
  def update_status
    if has_valid_gid?
      begin
        dict = Aria2.status gid, ["status", "errorCode"]
        self.status = dict["status"]
        
        case dict["status"]
        when "complete"
          self.gid  = nil
          self.info = {}
          self.completed_at = Time.now
        when "error"
          self.error = "ErrorCode: #{dict['errorCode']}"
        end
        res = save
      rescue
        res = false
      end
      
    else
      self.gid = nil
      info.delete "session"
      res = save
    end
    res
  end
  
  def has_valid_gid?
    begin
      invalid = (gid.nil? or info["session"].nil? or info["session"] != Aria2.this_session)
    rescue
      invalid = true
    end
    not invalid
  end
  
  class << self
    def add
      to_add.each { |download| download.add }
    end
    
    def update_status
      to_check.each { |download| download.update_status }
    end
  end
  
private
  def set_dir
    #FIXME: use conf file to generate better dirs
    options["dir"] = "/tmp/downloads" unless options.has_key? "dir"
  end
end
