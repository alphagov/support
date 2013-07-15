require 'active_model/tableless_model'
require 'support/gds/with_user_needs'
require 'test_helper'

module Support
  module GDS
    class TestModelWithUserNeeds < ActiveModel::TablelessModel
      include WithUserNeeds
    end

    class TestModelWithUserNeedsTest < Test::Unit::TestCase
      def request(attr = {})
        TestModelWithUserNeeds.new(attr)
      end

      should validate_presence_of(:user_needs)
      should allow_value(["", "govt_form"]).for(:user_needs)
      should allow_value(["inside_government_editor"]).for(:user_needs)
      should allow_value(["inside_government_writer"]).for(:user_needs)
      should allow_value(["other"]).for(:user_needs)
      should_not allow_value(["xxx"]).for(:user_needs)
      should_not allow_value([]).for(:user_needs)
      should_not allow_value([""]).for(:user_needs)

      should "know if it's related to inside government or not" do
        assert request(user_needs: ["inside_government_editor"]).inside_government_related?
        assert request(user_needs: ["inside_government_editor"]).inside_government_related?
        refute request(user_needs: ["govt_form"]).inside_government_related?
        refute request(user_needs: ["other"]).inside_government_related?
      end

      should "filter out empty choices for user needs (apparently it's a rails things with tickboxes)" do
        assert_equal "Other/Not sure", request(user_needs: ["", "other"]).formatted_user_needs
      end

      should "also define the formatted version" do
        assert_equal "Inside Government writer", request(user_needs: ["inside_government_writer"]).formatted_user_needs
        assert_equal "Inside Government editor, Inside Government writer", request(user_needs: ["inside_government_writer", "inside_government_editor"]).formatted_user_needs
      end
    end
  end
end
