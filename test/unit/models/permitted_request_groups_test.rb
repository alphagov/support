require 'test_helper'
require 'permitted_request_groups'

class PermittedRequestGroupsTest < Test::Unit::TestCase
  def setup
    @partially_accessible_request_classes = [
      stub("request class", accessible_by_user?: true, to_s: "accessible"),
      stub("request class", accessible_by_user?: false, to_s: "inaccessible")
    ]
    @inaccessible_classes = [stub("request class", accessible_by_user?: false)]
  end

  def test_that_request_groups_which_user_cannot_access_are_filtered_out
    request_groups = [
      stub("request group", title: "A", request_classes: @partially_accessible_request_classes),
      stub("request group", title: "B", request_classes: @inaccessible_classes)
    ]

    assert_equal ["A"], PermittedRequestGroups.new(nil, request_groups).to_a.map(&:title)
  end

  def test_that_request_classes_which_user_cannot_access_are_filtered_out
    request_groups = [ stub("request group", title: "A", request_classes: @partially_accessible_request_classes) ]

    assert_equal ["accessible"], PermittedRequestGroups.new(nil, request_groups).first.request_classes.map(&:to_s)
  end
end