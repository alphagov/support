require 'test_helper'
require 'support/requests/remove_user_request'

module Support
  module Requests
    class RemoveUserRequestTest < Test::Unit::TestCase
      def self.as_str(date)
        date.strftime("%d-%m-%Y")
      end

      def as_str(date)
        RemoveUserRequestTest.as_str(date)
      end

      should validate_presence_of(:requester)
      should validate_presence_of(:user_name)
      should validate_presence_of(:user_email)
      should validate_presence_of(:tool_role)

      should allow_value("ab@c.com").for(:user_email)
      should_not allow_value("ab").for(:user_email)

      should allow_value("was fired").for(:reason_for_removal)

      should "allow time constraints" do
        request = RemoveUserRequest.new(:time_constraint => stub("time constraint", :valid? => true))
        assert !request.time_constraint.nil?
        request.valid?
        assert_equal 0, request.errors[:time_constraint].size
      end
    end
  end
end