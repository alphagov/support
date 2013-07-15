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
      should validate_presence_of(:user_needs)
      should validate_presence_of(:action)

      should allow_value("create_new_user").for(:action)
      should allow_value("change_user").for(:action)
      should_not allow_value("xxx").for(:action)

      should allow_value("a comment").for(:additional_comments)

      should "provide action choices" do
        assert !request.action_options.empty?
      end

      should "provide formatted action" do
        assert_equal "New user account", request(action: "create_new_user").formatted_action

        assert request(action: "create_new_user").for_new_user?
        refute request(action: "change_user").for_new_user?
      end

      should "validate that the requested user is valid" do
        assert_not_nil request(requester: stub("user", valid?: true), requested_user: stub("user", valid?: false)).errors.get(:base)
      end
    end
  end
end