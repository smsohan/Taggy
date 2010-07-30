module SimilarityEngine
  module Learners
    class AbstractLearner
      def learn_relative_weights learning_data
        raise 'Method is not implented!'
      end
    end
  end  
end