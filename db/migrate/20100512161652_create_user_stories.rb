class CreateUserStories < ActiveRecord::Migration
  def self.up
    create_table :user_stories do |t|
      t.integer :project_id
      t.integer :sprint_id
      t.integer :owner_id
      t.string :title
      t.text :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :user_stories
  end
end
