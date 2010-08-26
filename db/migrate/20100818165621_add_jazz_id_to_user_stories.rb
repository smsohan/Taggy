class AddJazzIdToUserStories < ActiveRecord::Migration
  def self.up
    add_column :user_stories, :jazz_id, :string
  end

  def self.down
    remove_column :user_stories, :jazz_id
  end
end
