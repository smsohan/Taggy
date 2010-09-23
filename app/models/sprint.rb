class Sprint < ActiveRecord::Base
  attr_accessible :name, :project_id, :start_date, :end_date, :jazz_id
  validates_presence_of :start_date
  validates_presence_of :end_date
  belongs_to :project
  has_many :user_stories
  
  named_scope :nearby, lambda{|date| {:conditions => {:start_date => 2.months.ago(date)..2.months.from_now(date)}, :order => 'start_date'}}
  named_scope :current, lambda{|time| {:conditions => ["? BETWEEN start_date AND end_date", time.utc], :order => 'start_date'}}
  
  
  def pretty_duration
    if(start_date.year == end_date.year)
      if(start_date.month == end_date.month)
        return "#{start_date.strftime("%B %d")} - #{end_date.strftime("%d, %Y")}"
      else
        return "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
      end
    else
      return "#{start_date.strftime("%B %d, %Y")} - #{end_date.strftime("%B %d, %Y")}"
    end
  end
  
  def current?
    (start_date.to_date..end_date.to_date).include?(Date.today) 
  end
  
  def to_s
    "#{self.name}, #{self.pretty_duration}"
  end
  
  def messages
    self.project.messages.find(:all, :conditions => ['messages.created_at BETWEEN ? AND ?', self.start_date, self.end_date])
  end
  
  def instant_messages
    self.project.instant_messages.find(:all, :conditions => ['instant_messages.created_at BETWEEN ? AND ?', self.start_date, self.end_date])
  end
  

  protected  
  
  def validate
    super
    errors.add("end_date", "cannot be earlier than start date") if end_date && start_date && end_date < start_date
  end
end
