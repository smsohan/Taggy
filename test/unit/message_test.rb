require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  should belong_to :sender
  should belong_to :project
  should have_many :users
  should have_many :recipients
  should have_many :user_story_message_links
  should have_many :user_stories
  should have_many :attached_files
  
  [:sender, :subject].each {|attr| should validate_presence_of attr}

end
