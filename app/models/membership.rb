class Membership < ActiveRecord::Base                              
  belongs_to :project
  belongs_to :user
  belongs_to :role
  
  validates_presence_of :role_id
  
  named_scope :in_role, lambda { |role| {:include=>:role, :conditions =>{:roles => {:id => role.id}} } }
end
