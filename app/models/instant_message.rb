class InstantMessage < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :project
  has_and_belongs_to_many :users
  
  has_many :user_story_im_links, :dependent => :destroy
  has_many :user_stories, :through => :user_story_im_links              

  has_many :user_story_im_auto_links, :dependent => :destroy
  has_many :auto_linked_user_stories, :through => :user_story_im_auto_links, :source => :user_story
  
  named_scope :latest, :order => 'instant_messages.created_at DESC', :limit => 5   
  
  def people
    users
  end
  
  def find_similar_stories
    SimilarityEngine::Matchers::InstantMessageMatcher.new.matched_user_stories(self)
  end
  
  def glimpse
    truncate(content, :length => 200)
  end
  
end
