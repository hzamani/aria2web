class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id
  
  belongs_to :parent,      class_name: "Category", foreign_key: "parent_id"
  has_many :subcategories, class_name: "Category"
  has_many :downloads
  
  def path join=" > "
    parent.nil? ? name : parent.path + join + name
  end
  
  def name
    parent.nil? ? super : "#{parent.name} > #{super}"
  end
  
  def self.collection
    (all.map { |x| [x.name, x.id] }).sort
  end
end
