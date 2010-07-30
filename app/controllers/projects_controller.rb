class ProjectsController < ApplicationController
  def index
    @projects = params[:user_id].present? ? User.find(params[:user_id]).projects.uniq : Project.all
    @projects = @projects.sort_by{|project| project.name}
    @hide_project_selector = true
    add_crumb 'Projects'
  end
  
  def show
    @project = Project.find(params[:id])
    add_crumb 'Projects', user_projects_path(UserSession.current_user)
    add_crumb @project.name
  end
  
  def new
    @project = Project.new
    @project.users = User.all
  end
  
  def create
    @project = Project.new(params[:project])
    @project.memberships.build(:user_id => UserSession.current_user.id, :role_id => Role.default)
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to @project
    else
      render :action => 'new'
    end
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = "Successfully updated project."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end
end
