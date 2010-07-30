class CreateRelativeWeights < ActiveRecord::Migration
  def self.up
    create_table :relative_weights, :force => true do |t|
      t.float :date_weight
      t.float :people_weight
      t.float :subject_weight
      t.float :body_weight      
      t.timestamps
    end
  end

  def self.down
    drop_table :relative_weights
  end
end
