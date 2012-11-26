require 'test_helper'

class CreateNewUserRequestTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
  should validate_presence_of(:user_name)
  should validate_presence_of(:user_email)

  should allow_value("ab@c.com").for(:user_email)
  should_not allow_value("ab").for(:user_email)

  should allow_value("a comment").for(:additional_comments)
  should allow_value("yes").for(:inside_government)
end