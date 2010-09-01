module Jazz
  class Importer
    include REXML
    
    USER_NAME='ADMIN'
    PASSWORD='ADMIN'
    HOST="https://localhost:9443/jazz"      
    PROJECT_ID="_1w8aQEmJEduIY7C8B09Hyw"
    
    
    # 8 - APT
    # 9 - Build
    # 10 - CC connector
    
    def import_iteration_work_items taggy_project_id, iteration_id
      Rails.logger.level = 3
      connect
      login
      fetch_iteration_work_items taggy_project_id, iteration_id
      # CC M2 _HYdHMBVkEdyq7rav1hbatA
      # CC M1 _iRG6gOeXEdulCayttQeANg
      # 0.6 m1 APT 	_83nnkOEfEduUIrOBRKwTTQ
      #APT M0 _F79n4MV_EduSpdHmkiXnyw
      #APT ALL RC1  '_m-GMQIFIEduxPs-3vqCI3A'
      #Build M9 All '_uEg0cGTwEdu4dKFiuNZX2w' # Agile M9 All => "_JnQq4GKYEduf2b5WGb3T1Q"
      Rails.logger.level = 0
    end
        
    def curl
      return @curl if @curl
      @curl = Curl::Easy.new
      @curl.enable_cookies = true
      @curl.follow_location = true
      @curl.ssl_verify_peer = false
      @curl.ssl_verify_host = false
      @curl
    end

    def connect
      #get the cookies
      # curl -k -c $COOKIES "$HOST/authenticated/identity"
      curl.url = "#{HOST}/authenticated/identity"
      curl.http_get
      curl.body_str
    end
    
    def login
      # curl -k -L -b $COOKIES -c $COOKIES -d j_username=$USER -d j_password=$PASSWORD "$HOST/authenticated/j_security_check"
      curl.url = "#{HOST}/authenticated/j_security_check"
      curl.http_post "j_username=#{USER_NAME}&j_password=#{PASSWORD}"
      curl.body_str
    end
    
    def fetch_iteration_work_items taggy_project_id, iteration_id
      #https://localhost:9443/jazz/service/com.ibm.team.apt.internal.service.rest.IPlanRestService/plannedWorkItems?planId=_JnQq4GKYEduf2b5WGb3T1Q&projectAreaId=_1w8aQEmJEduIY7C8B09Hyw"
      curl.url = "#{HOST}/service/com.ibm.team.apt.internal.service.rest.IPlanRestService/plannedWorkItems?planId=#{iteration_id}&projectAreaId=#{PROJECT_ID}"
      curl.http_get
      doc = Document.new curl.body_str
      work_item_ids = doc.elements.collect("//workItems/workItemId") { |work_item_id| work_item_id.text }
      
      sprint_id = Project.find(taggy_project_id).sprints.find_by_jazz_id(iteration_id).id
      
      
      work_item_ids.each do |work_item_id| 
        story = UserStory.new
        story.project_id = taggy_project_id
        story.sprint_id = sprint_id        
        populate_user_story(story, work_item_id)
        story.save!
      end
      work_item_ids.join("_")
    end
    
    def populate_user_story user_story, work_item_id
      
      # https://localhost:9443/jazz/service/com.ibm.team.workitem.common.internal.rest.IWorkItemRestService/workItemDTO2?includeHistory=false&id=14466      
      curl.url = "#{HOST}/service/com.ibm.team.workitem.common.internal.rest.IWorkItemRestService/workItemDTO2?includeHistory=false&id=#{work_item_id}"
      curl.http_get      
      
      doc = Document.new curl.body_str
      attributes = XPath.match(doc, "//attributes")
      
      owner = user_from_attribute(attribute_for(attributes, :owner))

      user_story.assigned_users << owner if owner                                       
      
      user_story.owner        = user_from_attribute(attribute_for(attributes, :creator))
      user_story.title        = content_from_attribute(attribute_for(attributes, :summary))
      user_story.description  = content_from_attribute(attribute_for(attributes, :description)) 
      
      
      populate_messages(user_story, attributes)
      
      user_story
      
    end
    
    def populate_messages user_story, attributes
      comments_attribute = attribute_for(attributes, "internalComments")
      
      return unless comments_attribute
      
      comment_elements = XPath.match(comments_attribute, '//items').select{|attr| attr.elements["content"].present?}

      count = 0
      comment_elements.each do |comment_element|        
        message = Message.new
        message.project = user_story.project
        message.subject = "RE: #{user_story.title}"        
        message.body = comment_element.elements["content"].text
        message.sender =  user_from_attribute(comment_element.elements["creator"])
        message.created_at = comment_element.elements["creationDate"].text
        message.user_ids = user_story.people.collect{|user| user.id}

        user_story_message_link = UserStoryMessageLink.new()
        user_story_message_link.message = message
        user_story_message_link.user_story = user_story
        user_story.user_story_message_links << user_story_message_link
      end
       
    end
    
    def user_from_attribute user_attribute
      return nil unless user_attribute
      
      if user_attribute.elements["userId"]
        user_name = user_attribute.elements["userId"].text
      elsif user_attribute.elements["value"]
        user_name = user_attribute.elements["value"].elements["userId"].text
      end
      
      user = User.find_by_name(user_name)
      unless user
        user = User.create(:name => user_name, :email => "#{user_name}@email.org", :password => 'ssss', :password_confirmation=>'ssss' )
      end
      user
    end
    
    def content_from_attribute attribute
      return '' unless attribute      
      attribute.elements["value"].elements["content"].text
    end
    
    def attribute_for attributes, key
      attributes.select{|attr| attr.elements["key"].text == key.to_s}[0]
    end
  end
end