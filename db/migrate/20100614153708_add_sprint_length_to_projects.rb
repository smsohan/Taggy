class AddSprintLengthToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :sprint_length, :integer, :default => 14
  end

  def self.down
    remove_column :projects, :sprint_length
  end
end
