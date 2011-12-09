class Download < ActiveRecord::Base
  attr_accessible :uri
  
  serialize :options
  serialize :files
  serialize :info
  
  validates :uri, presence: true, uniqueness: true
  
  scope :removed,     where(removed: true)
  scope :all_exist,   where(removed: false)
  scope :all_ordered, all_exist.order(:status, :completed_at, :created_at)
  scope :to_add,      all_exist.where(status: :new)
  scope :to_check,    all_exist.where(status: [:added, :active])
  scope :to_clean,    all_exist.where(got:    true)
  scope :completed,   all_exist.where(status: :completed).order(:completed_at)
  
  before_create do
    self[:status]  = 'new'
    self[:options] = {}
    self[:info]    = {}
    self[:files]   = []
  end
  
  def got?()     got     end
  def removed?() removed end
  
  def toggle_got
    self.got = !got?
    save
  end
  
  def name
    if info.has_key? "name"
      info["name"] 
    elsif uri =~ /^https?:/u or uri =~ /^ftp:/u
      File.basename(uri).split('?').first
    elsif uri =~ /^magnet:/u
      uri.split("&").select{ |part| part =~ /^dn=/u }.first[3..-1]
    end
  end
  
  def add
    update_status
    if ["error", "new"].include? status
      begin
        set_dir
        self.gid        = Aria2.add uri, options 
        self.status     = "added"
        self.started_at = Time.now
        info["session"] = Aria2.this_session
        save
      rescue
        false
      end
    else
      false
    end
  end
  
  def update_status
    if has_valid_gid?
      begin
        keys = ["status", "errorCode", "files"]
        self.status, error, files_info = Aria2.status(gid, keys).values_at(*keys)
        
        unless info.has_key? "name" or files_info.empty?
          info["name"] = File.basename files_info.first["path"]
        end
        
        case status
        when "complete"
          self.gid   = nil
          self.info  = {}
          self.files = files_info.map { |f| f["path"] }
          self.completed_at = Time.now
        when "error"
          self.error = "ErrorCode: #{error}"
        else
          self.error = nil
        end
        
        save
      rescue
        false
      end
    else
      self.gid = nil
      info.delete "session"
      save
    end
  end
  
  def remove_files
    FileUtils.rm_rf files
    self.files_removed = true
    save
  end
  
  def remove
    self.removed = true and save
  end
  
  def has_valid_gid?
    not (gid.nil? ore info["session"] != Aria2.this_session)
  rescue
    false
  end
  
  class << self
    def add
      to_add.find_each { |download| download.add }
    end
    
    def update_status
      to_check.find_each { |download| download.update_status }
    end
    
    def clean
      to_clean.find_each { |download| download.remove_files }
    end
  end
  
private
  def set_dir
    #FIXME: use conf file to generate better dirs
    options["dir"] = "/tmp/downloads" unless options.has_key? "dir"
  end
end
