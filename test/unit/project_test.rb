require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  [:memberships,   :users,   :sprints,   :user_stories,   :messages,   :instant_messages].each {|rel| should have_many rel}
  should validate_numericality_of :sprint_length
end