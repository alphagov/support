require 'test_helper'

require 'shared/request'
require 'stub_user'

class ExampleRole
  def self.role_applies_to_user?(user)
    user.has_permission?('some_permission')
  end
end

class ExampleRequest < Request
  def self.accessible_by_roles
    [ExampleRole]
  end
end

class RequestTest < Test::Unit::TestCase
  def test_accessibility
    example_role_user = StubUser.new(["some_permission"])
    some_other_user = StubUser.new(["some_other_permission"])

    assert ExampleRequest.accessible_by_user?(example_role_user)
    refute ExampleRequest.accessible_by_user?(some_other_user)
  end
end