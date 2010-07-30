require 'test_helper'

class UserStoryTest < ActiveSupport::TestCase
  [:project, :sprint, :owner].each {|rel| should belong_to rel}  
  [:assignments, :assigned_users,  :messages, :user_story_message_links, :messages].each {|rel| should have_many rel}  
end
