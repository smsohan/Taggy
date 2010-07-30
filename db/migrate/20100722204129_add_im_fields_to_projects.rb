class AddImFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :instant_messenger_name, :string, :default => 'Skype'
    add_column :projects, :instant_messenger_user, :string
  end

  def self.down
    remove_column :projects, :instant_messenger_name
    remove_column :projects, :instant_messenger_user
  end
end
