class Download < ActiveRecord::Base
  attr_accessible :uri
  
  serialize :options
  serialize :info
  
  before_create do
    self[:status]  = 'new'
    self[:options] = {}
    self[:info]    = {}
  end
end
