class AttachedFile < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :message
  belongs_to :user_story  
  
  has_attached_file :file, 
              :url => "attached_files/:id", 
              :path => ":rails_root/public/system/attached_files/:id/:basename.:extension"
              
  validates_presence_of :name, :message => 'of Attached file cannot be blank'
   
  def url
    self.file.url
  end
  
  def path
    self.file.path
  end
  
  def name
    self.file.original_filename
  end
  
  def extract_content!                                      
    self.content = ActsAsSolr::Post.execute(SolrExtractContentRequest.new(path)).file_content(self.name)
    self.save!
  end
      
end
