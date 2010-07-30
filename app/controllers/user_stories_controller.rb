class UserStoriesController < ApplicationController
  def index
    @project = Project.find params[:project_id]
    @user_stories = @project.user_stories
    add_crumb @project.name, project_path(@project)
    add_crumb 'User Stories'
  end
  
  def show
    @user_story = UserStory.find(params[:id])
    add_crumb @user_story.project.name, project_path(@user_story.project)
    
    if @user_story.sprint    
      add_crumb 'Sprints', project_sprints_path(@user_story.project)
      add_crumb @user_story.sprint.name, project_sprint_path(@user_story.project, @user_story.sprint)
    end
    
    add_crumb @user_story.title
  end
  
  def new
    project = Project.find params[:project_id]
    @user_story = project.user_stories.build(:sprint_id => params[:sprint_id])
    add_crumb project.name, project_path(project)
    add_crumb(@user_story.sprint.name, project_sprint_path(project, @user_story.sprint)) if @user_story.sprint
    add_crumb 'New User Story'
  end
  
  def create
    params[:user_story][:assigned_user_ids] ||= []
    @user_story = UserStory.new(params[:user_story])
    if @user_story.save
      flash[:notice] = "Successfully created user story."
      redirect_to @user_story
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user_story = UserStory.find(params[:id])
    if @user_story.sprint    
      add_crumb 'Sprints', project_sprints_path(@user_story.project)
      add_crumb @user_story.sprint.name, project_sprint_path(@user_story.project, @user_story.sprint)
    end
    
    add_crumb @user_story.title, user_story_path(@user_story)
    add_crumb 'Edit'
  end
  
  def update
    params[:user_story][:assigned_user_ids] ||= []
    @user_story = UserStory.find(params[:id])
    if @user_story.update_attributes(params[:user_story])
      flash[:notice] = "Successfully updated user story."
      redirect_to @user_story
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user_story = UserStory.find(params[:id])
    @user_story.destroy
    flash[:notice] = "Successfully destroyed user story."
    redirect_to project_user_stories_url(@user_story.project)
  end
end
