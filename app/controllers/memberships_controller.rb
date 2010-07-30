class MembershipsController < ApplicationController
  def new
    @role = Role.find params[:role_id]
    @project = Project.find params[:project_id]
    @selected_users = @project.memberships.in_role(@role).collect{|membership| membership.user}
  end
  
  def create
    @project = Project.find params[:project_id]
    role = Role.find params[:role_id]
                            
    if params[:user_ids].present?
      users = User.find params[:user_ids]
      users.each do |user|
        @project.memberships.find_or_create_by_user_id_and_role_id(user.id, role.id)
      end                          
    end
    
    params[:user_ids] ||= []
    user_ids_to_remove_membership = @project.user_ids - params[:user_ids].collect{|user_id| user_id.to_i}
    
    user_ids_to_remove_membership.each do |user_id|
      membership = @project.memberships.find_by_user_id_and_role_id user_id, role.id
      membership.destroy if membership
    end
    
    flash[:notice] = 'Successfully selected project members'
    redirect_to @project
  end
end