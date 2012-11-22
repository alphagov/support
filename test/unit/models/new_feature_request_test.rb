require 'test_helper'

class NewFeatureRequestTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
  should validate_presence_of(:user_need)
  should allow_value("yes").for(:inside_government)
end