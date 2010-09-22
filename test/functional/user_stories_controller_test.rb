require 'test_helper'

class UserStoriesControllerTest < ActionController::TestCase
  def setup
    UserSession.create(users(:one))
  end
  
  
  def test_index
    get :index, :project_id => projects(:one).id
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => UserStory.first.id
    assert_template 'show'
  end
  
  def test_new
    get :new, :project_id => projects(:one).id
    assert_template 'new'
  end
  
  def test_create_invalid
    UserStory.any_instance.stubs(:valid?).returns(false)
    post :create, :user_story => {:project_id => projects(:one).id}
    assert_template 'new'
  end
  
  def test_create_valid
    UserStory.any_instance.stubs(:valid?).returns(true)
    post :create, :user_story => {:project_id => projects(:one).id}
    assert_redirected_to user_story_url(assigns(:user_story))
  end
  
  def test_edit
    get :edit, :id => UserStory.first.id
    assert_template 'edit'
  end
  
  def test_update_invalid
    UserStory.any_instance.stubs(:valid?).returns(false)
    put :update, :id => UserStory.first.id, :user_story => {}
    assert_template 'edit'
  end
  
  def test_update_valid
    UserStory.any_instance.stubs(:valid?).returns(true)
    put :update, :id => UserStory.first.id, :user_story=>{}
    assert_redirected_to user_story_url(assigns(:user_story))
  end
  
  def test_destroy
    user_story = UserStory.first
    delete :destroy, :id => user_story.id
    assert_redirected_to project_user_stories_url(user_story.project)
    assert !UserStory.exists?(user_story.id)
  end             
end
