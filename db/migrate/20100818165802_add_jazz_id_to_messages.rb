class AddJazzIdToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :jazz_id, :string
  end

  def self.down
    remove_column :messages, :jazz_id
  end
end
