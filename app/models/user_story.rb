class UserStory < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  attr_accessible :project_id, :sprint_id, :owner_id, :title, :description, :assigned_user_ids, :attachment
  belongs_to :project
  belongs_to :sprint
  
  has_many :assignments, :dependent => :destroy
  has_many :assigned_users, :through => :assignments, :source=>:user
  has_many :messages, :dependent => :destroy
  belongs_to :owner, :class_name => 'User'
  
  has_many :user_story_message_links, :dependent => :destroy
  has_many :messages, :through => :user_story_message_links
  
  has_many :user_story_message_auto_links, :dependent => :destroy
  has_many :auto_linked_messages, :through => :user_story_message_auto_links, :source => :message
  
  
  has_attached_file :attachment
  
  named_scope :worked_in, lambda {|sprint_ids| {:conditions => {:sprint_id => sprint_ids}} }
  named_scope :sprintless, :conditions => {:sprint_id => nil}
  
  
  acts_as_solr :fields => [:title, :description, :fake_id, :id], :facets =>[:fake_id]
  
  
  def glimpse
    truncate(title, :length => 80) 
  end
  
  def description_glimpse
    truncate(description, :length => 80) 
  end
  
  def people
    return assigned_users if owner.nil?    
    [owner] + assigned_users
  end
  
  def fake_id
    self.id
  end               
  
  def attachment?
    attachment.file?
  end
  
  def solr_add(doc)
    logger.debug "Inside solr_add with document:"
    logger.debug doc.to_xml.to_s
    if attachment?
      logger.debug "Has an attachment. Sending to solr for document indexing."
      result = ActsAsSolr::Post.execute(SolrCellRequest.new(doc, attachment.path, self.id))
      logger.debug "executed solr cell request for file #{result.inspect}"
    else
      super
    end
  end  
  
end
