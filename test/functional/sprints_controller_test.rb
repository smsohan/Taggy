require 'test_helper'

class SprintsControllerTest < ActionController::TestCase
  def test_index
    get :index, :project_id => projects(:one).id
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Sprint.first
    assert_template 'show'
  end
  
  def test_new
    get :new, :project_id => projects(:one).id
    assert_template 'new'
  end
  
  def test_create_invalid
    Sprint.any_instance.stubs(:valid?).returns(false)
    post :create, :sprint => {:project_id => projects(:one).id}
    assert_template 'new'
  end
  
  def test_create_valid
    Sprint.any_instance.stubs(:valid?).returns(true)
    post :create, :sprint => {:project_id => projects(:one).id}
    assert_redirected_to project_sprints_url(assigns(:sprint).project)
  end
  
  def test_edit
    get :edit, :id => Sprint.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Sprint.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Sprint.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Sprint.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Sprint.first
    assert_redirected_to sprint_url(assigns(:sprint))
  end
  
  def test_destroy
    sprint = Sprint.first
    delete :destroy, :id => sprint
    assert_redirected_to project_sprints_url(sprint.project)
    assert !Sprint.exists?(sprint.id)
  end
end
