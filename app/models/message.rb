class Message < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  DEFAULT_LEARNING_SET_SIZE=30

  attr_accessible :subject, :body, :from_user_id, :project_id, :user_story_id, :created_at, :user_ids, :user_story_ids, :attached_files_attributes
  belongs_to :project
  has_many :recipients, :dependent => :destroy
  has_many :users, :through => :recipients
  
  has_many :user_story_message_links, :dependent => :destroy
  has_many :user_stories, :through => :user_story_message_links              

  has_many :user_story_message_auto_links, :dependent => :destroy
  has_many :auto_linked_user_stories, :through => :user_story_message_auto_links, :source => :user_story

  
  has_many :attached_files, :dependent => :destroy
  
  belongs_to :sender, :class_name => 'User', :foreign_key => 'from_user_id'
  
  named_scope :latest, :order => 'messages.created_at DESC', :limit => 5   
  default_scope :order => 'messages.created_at DESC'
  
  validates_presence_of :user_ids, :if => Proc.new{|message| message.to.blank?}, :message => "Please select one/more recipient(s) (To)"
  validates_presence_of :subject, :message => 'Subject is required'
  validates_presence_of :sender, :if => Proc.new{|message| message.from.blank?},  :message => 'Sender is required'
  
  accepts_nested_attributes_for :attached_files
    
  after_save :extract_attachment_content
  
  def glimpse
    truncate(body, :length => 300)
  end
  
  def find_similar_stories(verbose=false)
    SimilarityEngine::Matchers::MessageMatcher.new(nil, verbose).matched_user_stories self
  end
  
  def auto_tag!(verbose=false)
    similar_stories = find_similar_stories(verbose) 
    return [] if similar_stories.blank?
    self.auto_linked_user_stories.clear
    self.auto_linked_user_stories << similar_stories
    self.save!
    similar_stories
  end
  
  def build_reply_to
    reply_message = Message.new
    reply_message.project = project
    reply_message.users = users + [sender]
    reply_message.subject = subject[0..2].downcase == 're:' ? subject : "RE: #{subject}"
    reply_message.created_at = created_at.succ
    reply_message.user_stories = user_stories
    reply_message
  end
  
  def self.learn_using messages_for_learning
    raise 'No Learning data found for the given arguments' if messages_for_learning.blank?
    puts "Messages_for_learning = #{messages_for_learning.length}"
    messages_for_learning.shuffle!
    data = SimilarityEngine::Learners::LearningData.new messages_for_learning
    SimilarityEngine::Learners::ReinforcementLearner.new(false).learn_relative_weights data
  end
  
  def self.auto_tag per_project_limit_percent_for_learning=DEFAULT_LEARNING_SET_SIZE    
    projects = Project.find [2, 3, 4]
    learn_tagging projects
    evaluate_tagging projects    
  end
  
  def self.learn_tagging projects, per_project_limit_percent_for_learning=DEFAULT_LEARNING_SET_SIZE
    messages_for_learning = []
    projects.each do |project|
      limit = project.messages.count * per_project_limit_percent_for_learning / 100
      puts "Project=#{project.id} limit=#{limit}"
      messages_for_learning += project.messages.find(:all, :limit => limit)
    end
    self.learn_using messages_for_learning    
  end
         
  def self.evaluate_tagging projects, per_project_limit_percent_for_learning=DEFAULT_LEARNING_SET_SIZE
    messages_for_evaluating = []
    evaluating_offset_percent = per_project_limit_percent_for_learning
    projects.each do |project|
      offset = evaluating_offset_percent * project.messages.count / 100
      limit = (100 - evaluating_offset_percent) * project.messages.count / 100
      
      guess = 0
      actually_linked = 0
      message_count = 0
      correct = 0
      project.messages.find(:all, :offset => offset, :limit => limit, :include => :user_stories).each do |message|
        message_count += 1
        
        stories = message.auto_tag!
        
        guess +=1 if stories.present?
        is_linked = message.user_stories.present?
        
        actually_linked += 1 if is_linked

        if (stories & message.user_stories).present? || (stories.blank? & !is_linked)
          correct += 1
          print "."
        else
          print "(#{message.id})"
        end
        STDOUT.flush
      end
      puts "======"
      puts "Project: #{project.name} Accuracy: #{correct * 100 / message_count} %"
      puts "Evaluation Messages: #{message_count}"
      puts "Correct Tagging: #{correct}"
      
      puts "Actually Linked Messages: #{actually_linked}"
      puts "Auto-Tagged Messages: #{guess}"

    end
  end
  
  def people
    users + [sender]
  end
  
  def extract_attachment_content
    self.reload
    return unless attached_files.present?
    
    attached_files.each {|af| af.extract_content! }
  end
  
  def body_with_attachment_content
    (body || '') + attached_files.collect{|af| af.content}.join(' ')
  end
  
  def self.create_from_email!(project, should_save=true)
    Mail::Configuration.instance.retriever_method :pop3, project.pop3_configuration

    new_messages = []        
                    
    Mail.all.each do |mail|
      message = project.messages.build       
      populate_message_from_email(message, mail)
      new_messages << message
            
      if should_save
        message.save!
        message.auto_tag!
      end
      
    end
    new_messages
  end
  
  protected
  def self.populate_message_from_email(message, mail)
    #from
    message.from        = mail.from.first  if mail.from.present?    
    message.sender      = User.find_by_email(message.from)

    #to & CC for record purpose only
    message.to          = mail.to.join(', ') if mail.to.present?        
    message.cc          = mail.cc.join(', ') if mail.cc.present?
                                    
    #find user instances and hook up if found
    puts "mail.to #{mail.to.inspect}"
    puts "mail.cc #{mail.cc.inspect}"                         
    
    to_with_cc          = (mail.to || []) + (mail.cc || [])
    to_with_cc.each do |message_to| 
      to_user = User.find_by_email(message_to)
      message.users << to_user if to_user.present?      
    end
    
    message.subject     = mail.subject || ''
     
    message.body        = mail.body.to_s
    message.created_at  = mail.date    
    message.attached_files = extract_attachments_from_email(mail)
  end  
  
  def self.extract_attachments_from_email mail
    mail.attachments.collect{|attachment| new_attached_file_from_email_attachment(attachment)}
  end
  
  def self.new_attached_file_from_email_attachment attachment
    attached_file = AttachedFile.new          
    StringIO.open(attachment.decoded) do |file_data|
      file_data.original_filename = attachment.filename
      file_data.content_type = attachment.content_type
      attached_file.file = file_data
    end
    attached_file
  end
  
end
