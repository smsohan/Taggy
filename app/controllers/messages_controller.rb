class MessagesController < ApplicationController
  def index
    @project =  Project.find(params[:project_id])
    @messages = @project.messages
    add_crumb @project.name, project_path(@project)
    add_crumb 'Messages'
  end
  
  def show
    @message = Message.find(params[:id])
    add_crumb @message.project.name, project_path(@message.project)
    add_crumb 'Messages', project_messages_path(@message.project)
    add_crumb @message.subject
  end
  
  def new
    project = nil
    
    if params[:old_message_id]
      @message= Message.find(params[:old_message_id]).build_reply_to
      project = @message.project
    else
      project = Project.find params[:project_id]    
      @message = project.messages.build
    end
    
    if params[:sprint_id]
      @sprint = Sprint.find(params[:sprint_id])
      @message.created_at = @sprint.start_date
    end

    if params[:user_story_id].present?
      @message.user_stories << UserStory.find(params[:user_story_id])
    end                       
    
    @message.attached_files.build(:project_id => project.id)
    
    add_crumb project.name, project_path(project)
    add_crumb 'Messages', project_messages_path(project)
    add_crumb 'New Message'
  end
  
  def create
    params[:message][:user_ids] ||= []
    params[:message][:user_story_ids] ||= []
    @message = Message.new(params[:message])
    
    @message.attached_files.each{|file| @message.attached_files.delete(file) unless file.valid?}
    unless Rails.env == 'development'
      @message.created_at = Time.now
      @message.sender = UserSession.current_user 
    end
    if @message.save
      @message.auto_tag!
      flash[:notice] = "Successfully created message."
      redirect_to @message
    else
      render :action => 'new'
    end
  end
  
  def edit
    @message = Message.find(params[:id])

    @message.attached_files.clear
    @message.attached_files.build :project_id => @message.project_id
    
    add_crumb @message.project.name, project_path(@message.project)
    add_crumb 'Messages', project_messages_path(@message.project)
    add_crumb @message.subject, message_path(@message)    
    add_crumb 'Edit'
  end
  
  def update
    sanitize_attached_file_attributes
    params[:message][:user_ids] ||= []
    params[:message][:user_story_ids] ||= []    
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      @message.auto_tag!
      flash[:notice] = "Successfully updated message."
      redirect_to @message
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:notice] = "Successfully destroyed message."
    redirect_to project_messages_url(@message.project)
  end
  
 private
 
 def sanitize_attached_file_attributes
   file_attibutes = params[:message][:attached_files_attributes]
   if file_attibutes
     file_attibutes.each_pair do|key, atttibute_values|
       params[:message][:attached_files_attributes].delete(key) if atttibute_values[:file].blank?
     end
   end
   params[:message][:attached_files_attributes] ||= Hash.new
      
 end
end
