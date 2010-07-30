class CreateInstantMessagesUsers < ActiveRecord::Migration
  def self.up
    create_table :instant_messages_users, :id => false, :force => true do |t|
      t.references :user
      t.references :instant_message
      t.timestamps
    end
  end

  def self.down
    drop_table :instant_messages_users
  end
end
