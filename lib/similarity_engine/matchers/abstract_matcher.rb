module SimilarityEngine
  module Matchers
    class AbstractMatcher
      def matched_user_stories matchable, limit=2
        raise 'Method is not implented!'
      end
    end
  end  
end