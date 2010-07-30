module SimilarityEngine
  module Matchers
    class MatcherFactory
      def matcher_for matchable
        # "#{matchable.class.to_s}Matcher".constantize.new
        "SimilarityEngine::Matchers::#{matchable.class.to_s}Matcher".constantize.new
      end
    end              
  end
end