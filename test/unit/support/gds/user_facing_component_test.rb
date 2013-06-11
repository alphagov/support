require 'test_helper'

require 'support/gds/user_facing_component'

def component(name)
  Support::GDS::UserFacingComponent.new(name: name)
end

module Support
  module GDS
    class UserFacingComponentTest < Test::Unit::TestCase
      should validate_presence_of(:name)
      should allow_value("gov_uk").for(:name)
      should allow_value("mainstream_publisher").for(:name)
      should allow_value("travel_advice_publisher").for(:name)
      should allow_value("inside_government_publisher").for(:name)
      should_not allow_value("xxx").for(:name)

      should "know if it's related to inside government or not" do
        assert component("inside_government_publisher").inside_government_related?
        refute component("gov_uk").inside_government_related?
        refute component("travel_advice_publisher").inside_government_related?
        refute component("mainstream_publisher").inside_government_related?
      end

      should "also define the formatted version" do
        assert_equal "Inside Government Publisher",
          component("inside_government_publisher").formatted_name
      end
    end
  end
end