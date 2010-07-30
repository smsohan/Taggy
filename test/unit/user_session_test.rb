require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  context 'as an activated session' do
    setup do
      activate_authlogic
    end
  end
end
