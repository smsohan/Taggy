class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.integer :user_id
      t.integer :message_id
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :recipients
  end
end
