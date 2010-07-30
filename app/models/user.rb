class User < ActiveRecord::Base
  acts_as_authentic    
  attr_accessible :name, :email, :password, :password_confirmation, :instant_messenger_name, :instant_messenger_user  
  has_many :memberships, :dependent => :destroy
  has_many :projects, :through => :memberships
  has_many :assignments, :dependent => :destroy
  has_many :assigned_user_stories, :through => :assignments, :source=>:user_story
  has_many :owned_user_stories, :class_name => 'UserStory', :foreign_key => 'owner_id'
  has_many :recipients
  has_many :messages, :through => :recipients
  
  def developer? project
    membership = self.memberships.find_by_project_id project.id
    membership && membership.role.developer?
  end  
end
