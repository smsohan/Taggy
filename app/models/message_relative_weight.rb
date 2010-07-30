class MessageRelativeWeight < RelativeWeight
  
  def self.instance
    self.first || create
  end
  
  def adjust is_correct, similarity_score

    return if similarity_score.nil?
    
    reward_value = is_correct ? 0.1 : -0.1
    
    self.date_weight   += (similarity_score.date_score >= 0.5) ? reward_value : -reward_value 
    self.people_weight += (similarity_score.people_score >= 0.5) ? reward_value : -reward_value
    self.subject_weight += (similarity_score.subject_score >= 0.5) ? reward_value : -reward_value     
    self.body_weight += (similarity_score.body_score >= 0.5) ? reward_value : -reward_value     
    
  end
  
  def gravitize
    self.date_weight = 0
    self.people_weight = 0
    self.subject_weight = 0
    self.body_weight = 0
  end
  
end