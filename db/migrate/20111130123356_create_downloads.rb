class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string   :uri
      t.string   :gid
      t.string   :status
      t.string   :options
      t.string   :files
      t.datetime :started_at
      t.datetime :completed_at
      t.string   :error
      t.text     :info
      t.boolean  :got,           default: false
      t.boolean  :keep,          default: false
      t.boolean  :removed,       default: false
      t.boolean  :files_removed, default: false
      
      t.timestamps
    end
  end
end
