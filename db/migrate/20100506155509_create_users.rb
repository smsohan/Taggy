class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password,    :null => false                # optional, see below
      t.string :password_salt,       :null => false                # optional, but highly recommended
      t.string :persistence_token,   :null => false                # required
      t.string :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      t.string :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
