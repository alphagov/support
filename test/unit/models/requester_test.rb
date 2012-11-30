require 'test_helper'

class RequesterTest < Test::Unit::TestCase
  should validate_presence_of(:email)

  should allow_value("ab@c.com").for(:email)
  should_not allow_value("ab").for(:email)
end