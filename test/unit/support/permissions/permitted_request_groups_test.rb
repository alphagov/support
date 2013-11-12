require 'test_helper'
require 'support/permissions/permitted_request_groups'

module Support
  module Permissions
    class PermittedRequestGroupsTest < Test::Unit::TestCase
      def setup
        @accessible = stub("request class", to_s: "accessible")
        @inaccessible = stub("request class", to_s: "inaccessible")
        @user = stub("user")
        @user.stubs(:can?).with(:create, @accessible).returns(true)
        @user.stubs(:can?).with(:create, @inaccessible).returns(false)
      end

      def test_that_request_groups_which_user_cannot_access_are_filtered_out
        request_groups = [
          stub("request group", title: "A", request_classes: [ @accessible, @inaccessible ]),
          stub("request group", title: "B", request_classes: [ @inaccessible ])
        ]

        assert_equal ["A"], PermittedRequestGroups.new(@user, request_groups).to_a.map(&:title)
      end

      def test_that_request_classes_which_user_cannot_access_are_filtered_out
        request_groups = [ stub("request group", title: "A", request_classes: [ @accessible, @inaccessible ]) ]

        names_of_permitted_request_classes = PermittedRequestGroups.new(@user, request_groups).first.request_classes.map(&:to_s)
        assert_equal ["accessible"], names_of_permitted_request_classes
      end
    end
  end
end