require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
    
  def test_new
      UserSession.find.destroy
      get :new
      assert_template 'new'
  end
    
  def test_create_invalid
    UserSession.find.destroy
    post :create, :user_session => {:email => 'gaga@example.com', :password => "adadads"}
    assert_template 'new'
  end

#   FIXME: 
  # def test_create_valid
  #   UserSession.any_instance.stubs(:valid?).returns(true)
  #   post :create, :user_session => {:email => 'one@example.com', :password => "benrocks"}
  #   assert_redirected_to root_path
  # end
    
  # def test_destroy 
  #   activate_authlogic
  #   UserSession.create(users(:one))
  #   delete :destroy
  #   assert_redirected_to login_path
  #   assert !UserSession.logged_in?    
  # end
end
