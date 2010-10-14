class InstantMessagesController < ApplicationController
  protect_from_forgery :except => :from_im 
  skip_before_filter :login_required, :only=> :from_im
  
  def index
    @project = Project.find(params[:project_id])
    @instant_messages = @project.instant_messages.all( :order => 'instant_messages.created_at DESC')
    add_crumb @project.name, project_path(@project)
    add_crumb 'Instant Messages'
  end
  
  def show
    @instant_message = InstantMessage.find(params[:id])
    add_crumb @instant_message.project.name, project_path(@instant_message.project)
    add_crumb 'Instant Messages', project_instant_messages_path(@instant_message.project) 
    add_crumb 'Instant Message'
  end
  
  def new
    @instant_message = Project.find(params[:project_id]).instant_messages.build
        
    if params[:sprint_id]
      @sprint = Sprint.find(params[:sprint_id])
      @instant_message.created_at = @sprint.start_date
    end
    
    if params[:user_story_id].present?
      @instant_message.user_stories << UserStory.find(params[:user_story_id])
    end                           
  end
  
  def create
    params[:instant_message][:user_ids] ||= []
    params[:instant_message][:user_story_ids] ||= []
    
    @instant_message = InstantMessage.new(params[:instant_message])
    if @instant_message.save
      @instant_message.auto_tag!
      flash[:notice] = "Successfully created instant message."
      redirect_to @instant_message
    else
      render :action => 'new'
    end
  end
  
  def edit
    @instant_message = InstantMessage.find(params[:id])
  end
  
  def update
    params[:instant_message][:user_ids] ||= []
    params[:instant_message][:user_story_ids] ||= []
    @instant_message = InstantMessage.find(params[:id])

    if @instant_message.update_attributes(params[:instant_message])
      @instant_message.auto_tag!
      flash[:notice] = "Successfully updated instant message."
      redirect_to @instant_message
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @instant_message = InstantMessage.find(params[:id])
    @instant_message.destroy
    flash[:notice] = "Successfully destroyed instant message."
    redirect_to project_instant_messages_url @instant_message.project
  end
  
  def from_im
    logger.info "PARAMS = " + params.inspect

    im_params = Hash.new
    params.each_pair{|k, v| im_params[k.to_s.gsub(/\"/, '').to_sym] = v.gsub(/[\"\']/, '')}

    instant_message = nil
    
    if InstantMessage.exists?(:source => im_params[:source], :identifier => im_params[:identifier])
      instant_message = InstantMessage.find_by_source_and_identifier(im_params[:source], im_params[:identifier])
      instant_message.content = "#{instant_message.content}\n#{im_params[:content]}"
    else
      project = Project.find_by_instant_messenger_name_and_instant_messenger_user(im_params[:source], im_params[:project_user]) 
      instant_message = project.instant_messages.build
      instant_message.content = im_params[:content]
      instant_message.source = im_params[:source]
      instant_message.identifier = im_params[:identifier]
    end
    
    
    im_params[:users].each do |im_user|
      user = User.find_by_instant_messenger_name_and_instant_messenger_user(im_params[:source], im_params[:project_user]) 
      instant_message.users << user if(user && !instant_message.users.include?(user))
    end
    
    instant_message.save!
    instant_message.auto_tag!
    render :text => 'Success'
  end
  
end
