require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should belong_to :user
  should belong_to :project
  should belong_to :role
end
