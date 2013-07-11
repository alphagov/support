require 'test_helper'
require 'support/requests/create_or_change_user_request'

module Support
  module Requests
    class CreateOrChangeUserRequestTest < Test::Unit::TestCase
      def request(options = {})
        CreateOrChangeUserRequest.new(options).tap { |r| r.valid? }
      end

      should validate_presence_of(:requester)
      should validate_presence_of(:requested_user)
      should validate_presence_of(:tool_role)
      should validate_presence_of(:action)

      should allow_value("create_new_user").for(:action)
      should allow_value("change_user").for(:action)
      should_not allow_value("xxx").for(:action)

      should allow_value("a comment").for(:additional_comments)

      should "provide action choices" do
        assert !CreateOrChangeUserRequest.new.action_options.empty?
      end

      should "provide formatted action" do
        assert_equal "New user account", CreateOrChangeUserRequest.new(action: "create_new_user").formatted_action
      end

      should "validate that the requested user is valid" do
        assert_not_nil request(requester: stub("user", valid?: true), requested_user: stub("user", valid?: false)).errors.get(:base)
      end
    end
  end
end