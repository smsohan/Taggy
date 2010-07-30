class AddInstantMessageApplicationAndNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :instant_messenger_name, :string, :default => 'Skype'
    add_column :users, :instant_messenger_user, :string 
  end

  def self.down
    remove_column :users, :instant_messenger_name
    remove_column :users, :instant_messenger_user
  end
end
