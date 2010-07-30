require 'test_helper'

class SprintTest < ActiveSupport::TestCase
  [:start_date, :end_date].each{ |attr| should validate_presence_of attr}
  should belong_to :project
  should have_many :user_stories
end
