class AddEmailFieldsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :pop3_server, :string, :default => 'pop.gmail.com'
    add_column :projects, :pop3_port,   :integer, :default => 995
    add_column :projects, :pop3_enable_ssl, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :pop3_server
    remove_column :projects, :pop3_port
    remove_column :projects, :pop3_enable_ssl
  end
end
