class AddJazzIdToSprints < ActiveRecord::Migration
  def self.up
    add_column :sprints, :jazz_id, :string
  end

  def self.down                                
    remove_column :sprints, :jazz_id
  end
end
