class RemoveUserIdFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :user_story_id
  end

  def self.down
    add_column :messages, :user_story_id, :integer
  end
end
