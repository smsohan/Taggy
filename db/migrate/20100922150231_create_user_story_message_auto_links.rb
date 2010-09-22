class CreateUserStoryMessageAutoLinks < ActiveRecord::Migration
  def self.up
    create_table :user_story_message_auto_links, :force => true do |t|
      t.integer :user_story_id
      t.integer :message_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_story_message_auto_links
  end
end
