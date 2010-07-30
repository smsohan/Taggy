class SprintsController < ApplicationController
  
  def index
    @project = Project.find(params[:project_id])
    @sprints = @project.sprints.all(:order => 'start_date DESC')
    add_crumb @project.name, project_path(@project)
    add_crumb 'Sprints'
  end
  
  def show
    @sprint = Sprint.find(params[:id])
    @messages = @sprint.project.messages.find(:all, :conditions=>['messages.created_at BETWEEN ? AND ?', @sprint.start_date, @sprint.end_date])
    add_crumb @sprint.project.name, project_path(@sprint.project)
    add_crumb 'Sprints', project_sprints_path(@sprint.project)
    add_crumb @sprint.name
  end
  
  def new
    @project = Project.find params[:project_id]
        
    sprint_name = ''
    if @project.sprints.present?
      final_sprint_name = @project.final_sprint.name
      if final_sprint_name =~ /\d$/
        sprint_name = final_sprint_name.succ
      end
    else
      sprint_name = 'Sprint#1'
    end
    
    @sprint = @project.sprints.build(:name => sprint_name)
    
    add_crumb @sprint.project.name, project_path(@sprint.project)
    add_crumb 'Sprints', project_sprints_path(@sprint.project)
    add_crumb 'New Sprint'
  end
  
  def create
    @sprint = Sprint.new(params[:sprint])
    if @sprint.save
      flash[:notice] = "Successfully created sprint."
      redirect_to project_sprints_path(@sprint.project)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sprint = Sprint.find(params[:id])
    add_crumb @sprint.project.name, project_path(@sprint.project)
    add_crumb 'Sprints', project_sprints_path(@sprint.project)
    add_crumb @sprint.name, project_sprint_path(@sprint.project, @sprint)
    add_crumb 'Edit'
  end
  
  def update
    @sprint = Sprint.find(params[:id])    
    if @sprint.update_attributes(params[:sprint])
      flash[:notice] = "Successfully updated sprint."
      redirect_to @sprint
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sprint = Sprint.find(params[:id])
    @sprint.destroy
    flash[:notice] = "Successfully destroyed sprint."
    redirect_to project_sprints_url @sprint.project
  end
end
