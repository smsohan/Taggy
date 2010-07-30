require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  should belong_to :user
  should belong_to :user_story
end
