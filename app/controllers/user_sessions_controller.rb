class UserSessionsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  def new
    redirect_to(projects_path) if UserSession.logged_in?
    @user_session = UserSession.new    
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_path
    else
      flash.now[:error] = 'Please use valid login credentials'
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to login_path
  end
end
