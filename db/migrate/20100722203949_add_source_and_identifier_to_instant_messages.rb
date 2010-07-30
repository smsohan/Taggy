class AddSourceAndIdentifierToInstantMessages < ActiveRecord::Migration
  def self.up
    add_column :instant_messages, :source, :string
    add_column :instant_messages, :identifier, :string
  end

  def self.down
    remove_column :instant_messages, :source
    remove_column :instant_messages, :identifier
  end
end
