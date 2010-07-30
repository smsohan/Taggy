class InstantMessage < ActiveRecord::Base
  attr_accessible :content, :project_id, :user_ids
  belongs_to :project
  has_and_belongs_to_many :users
  
  def people
    users
  end
  
  def find_similar_stories
    SimilarityEngine::Matchers::InstantMessageMatcher.new.matched_user_stories(self)
  end
  
end
