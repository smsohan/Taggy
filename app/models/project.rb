class Project < ActiveRecord::Base
  attr_accessible :name, :email, :password, :pop3_server, :pop3_port, :pop3_enable_ssl, :instant_messenger_name, :instant_messenger_user, :sprint_length
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :sprints
  has_many :user_stories, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :instant_messages
  
  validates_numericality_of :sprint_length, :message => "is not a number"
  
  def final_sprint
    sprints.all(:order => 'end_date DESC', :limit => 1).first
  end
  
  def current_sprint
    sprints.current(Time.now).first
  end
  
  def customers
    self.memberships.in_role(Role.customer).collect{|membership| membership.user}
  end

  def team
    self.memberships.in_role(Role.team).collect{|membership| membership.user}
  end
  
  def pop3_configuration
    {:user_name => email, :password => password, :address => pop3_server, :port => pop3_port, :enable_ssl => pop3_enable_ssl}   
  end                                               
  
  def grab_emails!
    Message.create_from_email!(self, should_save=true)
  end
  
  def self.grab_all_emails!
    Project.find(:all, :conditions => 'email IS NOT NULL').each do |project|
      begin
        if project.email.present?        
          project.grab_emails!
          logger.info "Grabbed emails for project #{project.name}"
        else
          logger.info "Did not grab emails for for project #{project.name}: no email given"          
        end
      rescue Exception => error
        logger.error "Exception in grabbing emails for project #{project.name}: #{error} at #{error.backtrace.join(',')}"
      end
    end
  end
  
end
