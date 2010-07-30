module SimilarityEngine
  module Learners
    class LearningData
      attr_accessor :messages
      
      def initialize messages=[]
        self.messages = messages
      end
      
    end
  end  
end