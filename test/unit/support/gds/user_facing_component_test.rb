require 'test_helper'

require 'support/gds/user_facing_component'

def component(attrs)
  Support::GDS::UserFacingComponent.new(attrs)
end

module Support
  module GDS
    class UserFacingComponentTest < Test::Unit::TestCase
      should validate_presence_of(:name)
      should allow_value(name: "gov_uk").for(:name)

      should "allow know whether components are Inside Government-related or not" do
        assert component(name: "inside_government_publisher", inside_government_related: true).inside_government_related?
        refute component(name: "gov_uk").inside_government_related?
      end
    end
  end
end