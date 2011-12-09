class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string  :name
      t.integer :parent_id
      
      t.timestamps
    end
    
    change_table :downloads do |t|
      t.integer :category_id
    end
  end
end
