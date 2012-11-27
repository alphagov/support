require 'tableless_model'
require 'with_tool_role_choice'
require 'test_helper'

class TestModelWithToolRoleChoice < TablelessModel
  include WithToolRoleChoice
end

class TestModelWithToolRoleChoiceTest < Test::Unit::TestCase
  should validate_presence_of(:tool_role)
  should allow_value("govt_form").for(:tool_role)
  should allow_value("inside_government_editor").for(:tool_role)
  should allow_value("inside_government_writer").for(:tool_role)
  should allow_value("other").for(:tool_role)
  should_not allow_value("xxx").for(:tool_role)

  should "know if it's related to inside government or not" do
    assert TestModelWithToolRoleChoice.new(:tool_role => "inside_government_editor").inside_government_related?
    assert TestModelWithToolRoleChoice.new(:tool_role => "inside_government_editor").inside_government_related?
    assert !TestModelWithToolRoleChoice.new(:tool_role => "govt_form").inside_government_related?
    assert !TestModelWithToolRoleChoice.new(:tool_role => "other").inside_government_related?
  end

  should "also define the formatted version" do
    assert "Inside Government writer", TestModelWithToolRoleChoice.new(:tool_role => "inside_government_writer").formatted_tool_role
  end
end