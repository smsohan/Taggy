class RelativeWeight < ActiveRecord::Base
  
  def to_s
    "date_weight =  #{date_weight} people_weight = #{people_weight} subject_weight = #{subject_weight} body_weight = #{body_weight}"
  end
  
end
