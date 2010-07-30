require 'test_helper'

class InstantMessageTest < ActiveSupport::TestCase
  should belong_to :project
  should have_and_belong_to_many :users
  
  context 'as an existing im' do
    setup do
      @instant_message = instant_messages(:one)
    end
    
    should 'return all users as people' do
      assert [users(:one), users(:two)], @instant_message.people
    end
    
    should 'call the similarity engine to find the similar stories' do
      SimilarityEngine::Matchers::InstantMessageMatcher.any_instance.expects(:matched_user_stories).with(@instant_message).returns([user_stories(:one)])
      assert_equal [user_stories(:one)], @instant_message.find_similar_stories
    end
    
  end
end
