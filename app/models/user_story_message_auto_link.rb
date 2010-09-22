class UserStoryMessageAutoLink < ActiveRecord::Base
  belongs_to :user_story
  belongs_to :message  
end
