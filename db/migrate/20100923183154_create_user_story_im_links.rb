class CreateUserStoryImLinks < ActiveRecord::Migration
  def self.up
    create_table :user_story_im_links do |t|
      t.integer :user_story_id
      t.integer :instant_message_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_story_im_links
  end
end
