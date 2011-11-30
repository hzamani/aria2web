class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string   :uri
      t.string   :gid
      t.string   :status
      t.string   :options
      t.datetime :completed_at
      t.string   :error
      t.text     :info
      
      t.timestamps
    end
  end
end
