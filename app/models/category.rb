class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id
  
  belongs_to :parent,      class_name: "Category", foreign_key: "parent_id"
  has_many :subcategories, class_name: "Category"
  has_many :downloads
  
  def path join=" > "
    parent.nil? ? name : parent.path + join + name
  end
  
  def self.collection
    (all.map { |x| [x.path, x.id] }).sort
  end
end
