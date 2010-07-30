module SimilarityEngine
  module Matchers
    class InstantMessageMatcher < MessageMatcher
      THRESHOLD=0.58
      DATE_SIMILARITY_BUFFER = 5      
      
      attr_accessor :relative_weight
      
      def initialize verbose=false
        self.relative_weight = InstantMessageRelativeWeight.instance
        @verbose = verbose
      end
            
      def similarity_score_between user_story, instant_message
        people_score  = people_similarity_score(user_story, instant_message)
        date_score    = date_similarity_score(user_story, instant_message)
        subject_score = 0
        body_score    = body_similarity_score(user_story, instant_message)
        SimilarityEngine::SimilarityScore.new(user_story, people_score, date_score, subject_score, body_score)
      end
      
      def body_similarity_score user_story, instant_message
        text_similarity_for_query user_story, instant_message.content, 0.3
      end
      
    end
  end
end