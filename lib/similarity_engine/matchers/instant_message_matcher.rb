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
      
      def subject_similarity_scores(filtered_user_stories, instant_message)
        score_hash(filtered_user_stories)
      end

      def body_similarity_scores user_stories, instant_message
        text_similarity_for_query user_stories, instant_message.content, 0.3
      end
      
    end
  end
end