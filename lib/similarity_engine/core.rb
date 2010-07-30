module SimilarityEngine
  class Core
    def matched_user_stories matchable
      matcher = Matchers::MatcherFactory.new.matcher_for matchable
      matcher.matched_user_stories matchable
    end
    
    def self.learn project_id
      data = SimilarityEngine::Learners::LearningData.new(Project.find(project_id).messages)
      learner = SimilarityEngine::Learners::ReinforcementLearner.new
      puts learner.learn_relative_weights(data)      
    end
  end
end 