require 'test_helper'

class InstantMessagesControllerTest < ActionController::TestCase
    
  def test_index
    get :index, :project_id => projects(:one).id
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => InstantMessage.first.id
    assert_template 'show'
  end
  
  def test_new
    get :new, :project_id => projects(:one).id
    assert_template 'new'
  end
  
  def test_create_invalid
    InstantMessage.any_instance.stubs(:valid?).returns(false)
    post :create, :instant_message => {:project_id => projects(:one).id}
    assert_template 'new'
  end
  
  def test_create_valid
    InstantMessage.any_instance.stubs(:valid?).returns(true)
    post :create, :instant_message => {:project_id => projects(:one).id}
    assert_redirected_to instant_message_url(assigns(:instant_message))
  end
  
  def test_edit
    get :edit, :id => InstantMessage.first.id
    assert_template 'edit'
  end
  
  def test_update_invalid
    InstantMessage.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InstantMessage.first.id, :instant_message => {}
    assert_template 'edit'
  end
  
  def test_update_valid
    InstantMessage.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InstantMessage.first.id, :instant_message => {}
    assert_redirected_to instant_message_url(assigns(:instant_message))
  end
  
  def test_destroy
    instant_message = InstantMessage.first
    delete :destroy, :id => instant_message.id
    assert_redirected_to project_instant_messages_url(instant_message.project)
    assert !InstantMessage.exists?(instant_message.id)
  end
end
