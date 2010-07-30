class Role < ActiveRecord::Base
  TEAM='Team'                 
  CUSTOMER='Customer'
  attr_accessible :name
    
  def self.team
    find_or_create_by_name Role::TEAM
  end
  
  def self.customer
    find_or_create_by_name Role::CUSTOMER
  end

  def self.default
    team
  end
  
end
