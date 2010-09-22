# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password
  
  before_filter :login_required
  
  add_crumb 'Home', '/'
  
  protected
  def login_required
    unless UserSession.logged_in?
      flash.now[:error] = 'Please login to proceed.'
      redirect_to login_path
    end
  end
end
