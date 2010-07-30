class UserSession < Authlogic::Session::Base
  def self.current
    find
  end

  def self.logged_in?
    self.current.present?
  end
  
  def self.current_user
    current && current.user
  end
end