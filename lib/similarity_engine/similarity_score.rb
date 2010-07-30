module SimilarityEngine
  class SimilarityScore
    attr_accessor :people_score, :date_score, :subject_score, :body_score, :user_story
    
    def initialize user_story=nil, people_score=nil, date_score=nil, subject_score=nil, body_score=nil
      self.user_story = user_story
      self.people_score = people_score
      self.date_score = date_score
      self.subject_score = subject_score
      self.body_score = body_score
    end
    
    def total_score  relative_weight                
      total_weight =  relative_weight.people_weight.to_f +  relative_weight.date_weight.to_f  +  relative_weight.subject_weight.to_f  +  relative_weight.body_weight.to_f
      
      return (relative_weight.people_weight.to_f * people_score.to_f +  relative_weight.date_weight.to_f * date_score.to_f + 
      relative_weight.subject_weight.to_f * subject_score.to_f + relative_weight.body_weight.to_f * body_score.to_f) /
      total_weight
    end
    
    
    def to_s
      "
      self.user_story_id = #{user_story.id}
      self.user_story = #{user_story.title}
      self.people_score = #{people_score}
      self.date_score = #{date_score}
      self.subject_score = #{subject_score}
      self.body_score = #{body_score}
      total_score = #{total_score(MessageRelativeWeight.instance)}"
    end
  end
end