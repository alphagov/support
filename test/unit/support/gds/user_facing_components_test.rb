require 'test_helper'

require 'support/gds/user_facing_components'

module Support
  module GDS
    class UserFacingComponentsTest < Test::Unit::TestCase
      should "be able to find components by name" do
        assert_equal UserFacingComponents.find("name" => "mainstream_publisher").id, "mainstream_publisher"
      end
    end
  end
end