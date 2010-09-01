require 'test_helper'
module SimilarityEngine
  module Matchers
    class MessageMatcherTest < ActiveSupport::TestCase
      def setup
        @matcher = MessageMatcher.new
      end
      
      def test_date_score_is_quarter_when_no_sprint_selected
        project = Project.new(:sprint_length => 14)
        user_story = project.user_stories.build(:title => 'title')
        user_story.project = project
      
        message = project.messages.build(:created_at => Time.now, :subject => 'subject')                         
        message.project = project
        assert_equal 0.25, @matcher.date_similarity_score(user_story, message)      
      end
        
      def test_date_score_is_negative_for_far_past
        test_date_score 1.month.ago, 15.days.ago, -1
      end    
        
      def test_date_score_is_negative_for_far_future
        test_date_score 15.days.from_now, 1.month.from_now, -1
      end   
      
      def test_date_score_is_half_inside_buffer_past
        test_date_score 16.days.ago, 3.day.ago, 0.5
      end
     
     def test_date_score_is_half_inside_buffer_future
       test_date_score 4.days.from_now, 18.days.from_now, 0.5        
     end
     
     def test_date_score_is_zero_beyond_buffer_past
       test_date_score 18.days.ago, 6.day.ago, 0
     end
     
     def test_date_score_is_zero_beyond_buffer_future
       test_date_score 6.days.from_now, 20.days.from_now, 0
     end
     
     def test_date_score_is_one_inside_sprint
       test_date_score 7.days.ago, 7.days.from_now, 1
     end
               
      def test_people_similarity_is_zero_when_no_common_people
        test_people_score User.new, [User.new, User.new], [], 0
        test_people_score User.new, [User.new, User.new], [User.new, User.new], 0
      end
      
      def test_people_similarity_is_one_when_all_common_people
        one = User.new
        two = User.new
        test_people_score one, [two], [one, two], 1
      end 
                         
      def test_people_similarity_is_half_when_one_of_two_are_people
        one = User.new
        two = User.new
        test_people_score one, [two], [one, User.new], 0.5
      end
      
      private
      
      def test_people_score message_sender, message_users, story_people, value        
        
        user_story = UserStory.new
        message = Message.new
        
        user_story.assigned_users = story_people
        message.sender = message_sender
        message.users = message_users
        assert_equal value, @matcher.people_similarity_score(user_story, message)
      end
      
      def test_date_score sprint_start_date, sprint_end_date, similarity_value
        project = Project.new(:sprint_length => 14)
        sprint = project.sprints.build(:start_date => sprint_start_date, :end_date => sprint_end_date)
        user_story = project.user_stories.build(:title => 'title')
        user_story.sprint = sprint
        user_story.project = project
        
        message = project.messages.build(:created_at => Time.now, :subject => 'subject')                            
        message.project = project
        assert_equal similarity_value, @matcher.date_similarity_score(user_story, message)
      end
  
    end
  end
end