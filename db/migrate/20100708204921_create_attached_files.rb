class CreateAttachedFiles < ActiveRecord::Migration
  def self.up
    create_table :attached_files do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.references :project
      t.references :message
      t.references :user_story
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :attached_files
  end
end
