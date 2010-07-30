class CreateInstantMessages < ActiveRecord::Migration
  def self.up
    create_table :instant_messages do |t|
      t.text :content
      t.integer :project_id
      t.string :application_name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :instant_messages
  end
end
