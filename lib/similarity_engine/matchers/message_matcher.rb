module SimilarityEngine
  module Matchers
    class MessageMatcher < AbstractMatcher
      THRESHOLD=0.58
      DATE_SIMILARITY_BUFFER = 5      
      
      attr_accessor :relative_weight
      
      def initialize relative_weight=nil, verbose=false
        self.relative_weight = relative_weight || MessageRelativeWeight.instance
        @verbose = verbose
      end
      
      def matched_user_stories message, limit=2
        scores_for_matched_user_stories(message).collect{|score| score.user_story }[0..(limit-1)]
      end
      
      def scores_for_matched_user_stories message
        sprint_ids = message.project.sprints.nearby(message.created_at.to_date).find(:all, :select => 'id')
        filtered_user_stories = message.project.user_stories.worked_in(sprint_ids) + message.project.user_stories.sprintless
        
        above_threshold_scores = []
        filtered_user_stories.each do |user_story|
          score = similarity_score_between(user_story, message)          
          if(score.total_score(relative_weight) > THRESHOLD)
            above_threshold_scores << score 
            puts score if @verbose
          end
        end        
                
        above_threshold_scores.sort_by{|score| -score.total_score(relative_weight)}                
      end
      
      def similarity_score_between user_story, message
        people_score  = (self.relative_weight.people_weight == 0) ? 0 : people_similarity_score(user_story, message)
        date_score    = (self.relative_weight.date_weight == 0) ? 0 : date_similarity_score(user_story, message)
        subject_score = (self.relative_weight.subject_weight == 0) ? 0 : subject_similarity_score(user_story, message)
        body_score    = (self.relative_weight.body_weight == 0) ? 0 : body_similarity_score(user_story, message)
        SimilarityEngine::SimilarityScore.new(user_story, people_score, date_score, subject_score, body_score)
      end
      
      def people_similarity_score user_story, message        
        user_story_people = user_story.people
        message_people = message.people
        common_people = message_people & user_story_people
        
        score = nil        
        score = 1 if common_people.length == user_story_people.length
        
        score = (common_people.length * 1.0 / user_story_people.length) if common_people.present? && common_people.length < user_story_people.length
        
        score = 0 if common_people.blank?

        return score     
      end
      
      def date_similarity_score user_story, message
        return 0.25 if user_story.sprint.nil?
        
        return 1 if (message.created_at >= user_story.sprint.start_date && message.created_at <= user_story.sprint.end_date)
        
        return 0.5 if (
                      message.created_at >= (user_story.sprint.start_date - DATE_SIMILARITY_BUFFER.days) && 
                      message.created_at <= (user_story.sprint.end_date + DATE_SIMILARITY_BUFFER.days)
                      )
                      
        return 0 if ( 
                     message.created_at >= (user_story.sprint.start_date - user_story.project.sprint_length.days) && 
                     message.created_at <= (user_story.sprint.end_date + user_story.project.sprint_length.days)
                     )
        return -1
      end
      
      def subject_similarity_score user_story, message
        text_similarity_for_query user_story, message.subject, 0.4
      end
      
      def body_similarity_score user_story, message
        text_similarity_for_query user_story, message.body_with_attachment_content, 0.3
      end
      
      protected
      
      def text_similarity_for_query user_story, query, threshold
        return 0 if query.blank?
        begin
          query = query.gsub('!', '').gsub(/[\(\)\r\n\:\;\{\}\+\-\$\'\?\~\|\=\[\]"\*]/,' ').gsub(/ and /, '').gsub(/ or /, '').gsub(/ between /,'')        
          result = UserStory.find_by_solr query, :operator => :or, :scores => true, :filter_queries => "pk_i:#{user_story.id}"
          return result.docs.present? ? clipped_text_similarity_score(result.docs.first.solr_score, threshold) : 0        
        rescue Exception => error
          Rails.logger.error "Exception in finding text similarity #{error.message} at #{error.backtrace.join(", ")}"
          return 0
        end          
      end
      
      def clipped_text_similarity_score solr_score, threshold
        almost_similar = threshold
        solr_score >= almost_similar ? 1 : solr_score / almost_similar
      end
      
    end
  end  
end