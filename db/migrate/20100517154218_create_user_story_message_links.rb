class CreateUserStoryMessageLinks < ActiveRecord::Migration
  def self.up
    create_table :user_story_message_links do |t|
      t.integer :message_id
      t.integer :user_story_id
      t.boolean :confirmed
      t.timestamps
    end
  end

  def self.down
    drop_table :user_story_message_links
  end
end
