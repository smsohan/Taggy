class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :from_user_id
      t.integer :project_id
      t.integer :user_story_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :messages
  end
end
