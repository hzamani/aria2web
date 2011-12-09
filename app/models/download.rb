class Download < ActiveRecord::Base
  attr_accessible :uri, :category_id
  
  belongs_to :category
  
  serialize :options
  serialize :files
  serialize :info
  
  validates :uri,      presence: true, uniqueness: true
  validates :category, presence: true
  
  scope :removed,     where(removed: true)
  scope :all_exist,   where(removed: false)
  scope :all_ordered, all_exist.order(:status, :completed_at, :created_at)
  scope :to_add,      all_exist.where(status: :new)
  scope :to_check,    all_exist.where(status: [:added, :active])
  scope :to_clean,    all_exist.where(got:    true)
  scope :completed,   all_exist.where(status: :completed).order(:completed_at)
  
  before_create do
    self[:status]  = "new"
    self[:options] = {}
    self[:info]    = {}
    self[:files]   = []
  end
  
  def got?() got end
  def toggle_got
    self.got = !got
    save
  end
  
  def keep?() keep end
  def toggle_keep
    self.keep = !keep
    save
  end
  
  def removed?() removed end
  def remove
    self.removed = true
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
end
