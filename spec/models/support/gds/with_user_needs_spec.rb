require 'spec_helper'
require 'active_model/tableless_model'
require 'support/gds/with_user_needs'

module Support
  module GDS
    class TestModelWithUserNeeds < ActiveModel::TablelessModel
      include WithUserNeeds
    end

    describe TestModelWithUserNeeds do
      def request(attr = {})
        TestModelWithUserNeeds.new(attr)
      end

      it { should validate_presence_of(:user_needs) }
      it { should allow_value(["", "other"]).for(:user_needs) }
      it { should allow_value(["inside_government_editor"]).for(:user_needs) }
      it { should allow_value(["inside_government_writer"]).for(:user_needs) }
      it { should allow_value(["other"]).for(:user_needs) }
      it { should_not allow_value(["xxx"]).for(:user_needs) }
      it { should_not allow_value([]).for(:user_needs) }
      it { should_not allow_value([""]).for(:user_needs) }

      it "knows if it's related to inside government or not" do
        expect(request(user_needs: ["inside_government_editor"])).to be_inside_government_related
        expect(request(user_needs: ["inside_government_editor"])).to be_inside_government_related
        expect(request(user_needs: ["user_manager"])).to_not be_inside_government_related
        expect(request(user_needs: ["other"])).to_not be_inside_government_related
      end

      it "filters out empty choices for user needs (apparently it's a rails things with tickboxes)" do
        expect(request(user_needs: ["", "other"]).formatted_user_needs).to eq("Other/Not sure")
      end

      it "defines the formatted version" do
        expect(request(user_needs: ["inside_government_writer"]).formatted_user_needs).
          to eq("Departments and policy writer permissions")
        expect(request(user_needs: ["inside_government_writer", "inside_government_editor"]).formatted_user_needs).
          to eq("Departments and policy editor permissions, Departments and policy writer permissions")
      end
    end
  end
end
