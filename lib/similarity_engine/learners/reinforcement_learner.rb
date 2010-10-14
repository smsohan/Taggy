module SimilarityEngine
  module Learners
    class ReinforcementLearner
      def initialize verbose=false 
        @verbose = verbose
      end
      def learn_relative_weights learning_data               
        relative_weight = initial_relative_weight learning_data
        # relative_weight = RelativeWeight.instance
        # relative_weight.attributes = {:date_weight => 25, :people_weight => 15, :subject_weight => 35, :body_weight => 25}
        puts "Initial Relative Weight = #{relative_weight}"
        
        
        matcher = SimilarityEngine::Matchers::MessageMatcher.new(relative_weight)
        total_correct = 0
        learning_data.messages.each do |message|
          puts "Matching Message id=#{message.id} subject =#{message.subject}"
          similarity_scores = matcher.scores_for_matched_user_stories(message)
          
          is_correct = false
          
          if message.user_stories.blank?
            is_correct = ! similarity_scores.present?
          elsif similarity_scores.present?
            similarity_scores.each do |similarity_score|
              is_correct = message.user_stories.include?(similarity_score.user_story)
              relative_weight.adjust(is_correct, similarity_score)
              break if is_correct
            end            
          end                                                                     
               
          total_correct +=1 if is_correct
          

          puts "Correct?#{is_correct} Current Relative Weight = #{relative_weight}"
        end
        
        relative_weight.save!
        
        im_relative_weight = InstantMessageRelativeWeight.instance
        
        im_relative_weight.people_weight = relative_weight.people_weight
        im_relative_weight.date_weight = relative_weight.date_weight
        im_relative_weight.subject_weight = 0
        im_relative_weight.body_weight = relative_weight.subject_weight + relative_weight.body_weight
        im_relative_weight.save!
                
        puts "total correct = #{total_correct}"
        relative_weight                
      end
      
      
      private
      def initial_relative_weight learning_data
        people_correct = correct_guess_using_only_people(learning_data)        
        puts "Correct usng only people = #{people_correct}"
        
        date_correct = correct_guess_using_only_date(learning_data)
        puts "Correct usng only date = #{date_correct}"

        subject_correct = correct_guess_using_only_subject(learning_data)
        puts "Correct usng only subject = #{subject_correct}"

        body_correct = correct_guess_using_only_body(learning_data)
        puts "Correct usng only body = #{body_correct}"
        
                
        total_correct = people_correct +  date_correct + subject_correct + body_correct
        
        raise 'Invalid Algorithm Error! Not a single classification was correct!' if total_correct.zero?
        
        relative_weight = gravitized_relative_weight
        relative_weight.people_weight = (people_correct * 100 / total_correct)
        relative_weight.date_weight = date_correct * 100 / total_correct
        relative_weight.subject_weight = subject_correct * 100 / total_correct
        relative_weight.body_weight = body_correct * 100 / total_correct

        relative_weight
      end
      
      
      def correct_guess_using_only_people learning_data
        relative_weight = gravitized_relative_weight
        relative_weight.people_weight = 1
        correct_guess_using_relative_weight relative_weight, learning_data
      end
      
      def correct_guess_using_only_date learning_data
        relative_weight = gravitized_relative_weight
        relative_weight.date_weight = 1
        correct_guess_using_relative_weight relative_weight, learning_data
      end
      
      def correct_guess_using_only_subject learning_data
        relative_weight = gravitized_relative_weight
        relative_weight.subject_weight = 1
        correct_guess_using_relative_weight relative_weight, learning_data
      end
      
      def correct_guess_using_only_body learning_data
        relative_weight = gravitized_relative_weight
        relative_weight.body_weight = 1
        correct_guess_using_relative_weight relative_weight, learning_data
      end
      
      def correct_guess_using_relative_weight relative_weight, learning_data
        puts "Guessing using " << relative_weight.to_s
        matcher = SimilarityEngine::Matchers::MessageMatcher.new(relative_weight)
        correct_count = 0

        learning_data.messages.each do |message|
          user_stories = matcher.matched_user_stories(message)
          puts "Matching message =#{message.id} #{message.subject}" if @verbose
          if (user_stories & message.user_stories).present?
            correct_count += 1
            puts "Correct"  if @verbose
          else                                                   
            puts "Incorrect"  if @verbose
          end
        end
        
        correct_count        
      end
      
      
      def gravitized_relative_weight
        relative_weight = MessageRelativeWeight.instance
        relative_weight.gravitize
        relative_weight
      end
      
    end
  end  
end