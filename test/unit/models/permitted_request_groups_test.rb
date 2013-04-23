require 'test_helper'
require 'permitted_request_groups'

class PermittedRequestGroupsTest < Test::Unit::TestCase
  def setup
    @accessible = stub("request class", to_s: "accessible")
    @inaccessible = stub("request class", to_s: "inaccessible")
    @user = stub("user")
    @user.stubs(:can?).with(:modify, @accessible).returns(true)
    @user.stubs(:can?).with(:modify, @inaccessible).returns(false)
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