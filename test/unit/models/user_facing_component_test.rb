require 'shared/tableless_model'
require 'technical_fault_report/user_facing_component'
require 'test_helper'

def component(name)
  UserFacingComponent.new(name: name)
end

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
    assert_equal "Inside Government Publisher", \
      component("inside_government_publisher").formatted_name
  end
end