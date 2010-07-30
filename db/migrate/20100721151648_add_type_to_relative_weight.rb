class AddTypeToRelativeWeight < ActiveRecord::Migration
  def self.up
    add_column :relative_weights, :type, :string
  end

  def self.down
    remove_column :relative_weights, :type
  end
end
