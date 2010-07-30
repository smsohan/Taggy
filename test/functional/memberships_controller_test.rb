require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase     
  def test_shows_new_form
    get :new, {:role_id => Role.team.id, :project_id => projects(:one).id}
    assert_template :new
    assert assigns(:role)
    assert assigns(:project)
    assert assigns(:selected_users)    
  end
  
  def test_create
    post :create, {:project_id => projects(:one).id, :role_id => Role.team.id, :user_ids => [users(:one).id]}
    assert_redirected_to projects(:one)
  end
end