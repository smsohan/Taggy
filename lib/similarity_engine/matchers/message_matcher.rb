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
        Rails.logger.debug "Sprint ids = #{sprint_ids.inspect}"
        puts("Sprint ids = #{sprint_ids.inspect}") if @verbose
        
        filtered_user_stories = message.project.user_stories.worked_in(sprint_ids) + message.project.user_stories.sprintless
        Rails.logger.debug "user stories = #{filtered_user_stories}"
        puts ("user stories = #{filtered_user_stories}") if @verbose
        
        subject_scores = subject_similarity_scores(filtered_user_stories, message)
        body_scores = body_similarity_scores(filtered_user_stories, message)
        date_scores = date_similarity_scores(filtered_user_stories, message)
        people_scores = people_similarity_scores(filtered_user_stories, message)        
        
        above_threshold_scores = []
        
        
        filtered_user_stories.each do |user_story|
          score = SimilarityEngine::SimilarityScore.new(user_story, 
                                                        people_scores[user_story.id], 
                                                        date_scores[user_story.id], 
                                                        subject_scores[user_story.id], 
                                                        body_scores[user_story.id])
          puts score if @verbose
          if(score.total_score(relative_weight) > THRESHOLD)
            above_threshold_scores << score 
            puts score if @verbose
          end
        end        
                
        above_threshold_scores.sort_by{|score| -score.total_score(relative_weight)}                
      end
      
      def people_similarity_scores user_stories, message
        people_scores_hash = score_hash(user_stories)
        user_stories.each {|story| people_scores_hash[story.id] = people_similarity_score(story, message)}
        people_scores_hash
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
      
      def date_similarity_scores user_stories, message
        date_scores_hash = score_hash(user_stories)
        user_stories.each {|story| date_scores_hash[story.id] = date_similarity_score(story, message)}
        date_scores_hash
      end
      
      def date_similarity_score user_story, message
        buffer = message.project.sprint_length ? ( message.project.sprint_length / 3 ) : DATE_SIMILARITY_BUFFER
        
        return 0.25 if user_story.sprint.nil?
        
        return 1 if (message.created_at >= user_story.sprint.start_date && message.created_at <= user_story.sprint.end_date)
        
        return 0.5 if (
                      message.created_at >= (user_story.sprint.start_date - buffer.days) && 
                      message.created_at <= (user_story.sprint.end_date + buffer.days)
                      )
                      
        return 0 if ( 
                     message.created_at >= (user_story.sprint.start_date - user_story.project.sprint_length.days) && 
                     message.created_at <= (user_story.sprint.end_date + user_story.project.sprint_length.days)
                     )
        return -1
      end
      
      def subject_similarity_scores user_stories, message
        text_similarity_for_query user_stories, message.subject, 0.4
      end
      
      def body_similarity_scores user_stories, message
        text_similarity_for_query user_stories, message.body_with_attachment_content, 0.3
      end
      
      
      protected
            
      def text_similarity_for_query user_stories, query, threshold
        text_scores = score_hash(user_stories)
        
        filter_q = solr_filter_query(user_stories.collect{|story| story.id})
        Rails.logger.debug "Filter query = #{filter_q}"
        
        begin
          query = query.gsub('!', '').gsub(/[\(\)\r\n\:\;\{\}\+\-\$\'\?\~\|\=\[\]"\*]/,' ').gsub(/ and /, '').gsub(/ or /, '').gsub(/ between /,'')        
          result = UserStory.find_by_solr query, :operator => :or, :scores => true, :filter_queries => filter_q
          if result.docs.present?
            result.docs.each do |user_story|
              text_scores[user_story.id] = clipped_text_similarity_score(user_story.solr_score, threshold)
            end
          end          
        rescue Exception => error
          Rails.logger.error "Exception in finding text similarity #{error.message} at #{error.backtrace.join(", ")}"
        end
        
        return text_scores
      end
      
      def score_hash user_stories 
        score_hash_obj = Hash.new
        user_stories.each{|story| score_hash_obj[story.id] = 0}
        score_hash_obj
      end
      
      def clipped_text_similarity_score solr_score, threshold
        almost_similar = threshold
        solr_score >= almost_similar ? 1 : solr_score / almost_similar
      end
      
      def solr_filter_query user_story_ids
        user_story_ids.collect{|user_story_id| "pk_i:#{user_story_id}"}.join(" OR ")
      end
      
    end
  end  
end