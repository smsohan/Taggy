require 'test_helper'

class UserTest < ActiveSupport::TestCase
  [:memberships, :projects, :assignments, :assigned_user_stories, 
    :owned_user_stories, :recipients, :messages].each {|rel| should have_many rel}
  
end
