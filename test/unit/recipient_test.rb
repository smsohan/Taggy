require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  [:user, :message].each {|rel| should belong_to rel}
end
