class UserStoryImAutoLink < ActiveRecord::Base
  belongs_to :user_story
  belongs_to :instant_message
end
