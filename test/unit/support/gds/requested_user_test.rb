require 'test_helper'
require 'support/gds/requested_user'

module Support
  module GDS
    class RequestedUserTest < Test::Unit::TestCase
      should validate_presence_of(:name)
      should validate_presence_of(:email)
      should validate_presence_of(:job)

      should allow_value("07911111").for(:phone)

      should allow_value("ab@c.com").for(:email)
      should_not allow_value("ab").for(:email)
    end
  end
end