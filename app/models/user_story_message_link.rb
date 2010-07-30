class UserStoryMessageLink < ActiveRecord::Base
  belongs_to :user_story
  belongs_to :message
  
  after_initialize :set_confirmed
  
  def set_confirmed
    confirmed = true if confirmed.nil?
  end
end
