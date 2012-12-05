require 'test_helper'

class CreateNewUserRequestTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
  should validate_presence_of(:requested_user)
  should validate_presence_of(:tool_role)

  should allow_value("a comment").for(:additional_comments)
end