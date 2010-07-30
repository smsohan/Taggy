class AddEmailPeopleToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :from, :string
    add_column :messages, :to, :string
    add_column :messages, :cc, :string
  end

  def self.down
    remove_column :messages, :from
    remove_column :messages, :to
    remove_column :messages, :cc
  end
end
