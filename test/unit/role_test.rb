require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  should 'return customer role' do
    assert 'Customer', Role.customer
  end
  should 'return team role' do
    assert 'Team', Role.team
  end
  
end
