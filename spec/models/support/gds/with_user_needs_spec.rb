require 'spec_helper'
require 'active_model/model'
require 'support/gds/with_user_needs'

module Support
  module GDS
    class TestModelWithUserNeeds
      include ActiveModel::Model
      include WithUserNeeds
    end

    describe TestModelWithUserNeeds do
      def request(attr = {})
        TestModelWithUserNeeds.new(attr)
      end

      it { should validate_presence_of(:user_needs) }
      it { should allow_value("other").for(:user_needs) }
      it { should allow_value("editor").for(:user_needs) }
      it { should allow_value("writer").for(:user_needs) }
      it { should allow_value("other").for(:user_needs) }
      it { should_not allow_value("xxx").for(:user_needs) }
      it { should_not allow_value(["other", "editor"]).for(:user_needs) }
      it { should_not allow_value([""]).for(:user_needs) }

      it "knows if it's related to inside government or not" do
        expect(request(user_needs: "writer")).to be_inside_government_related
        expect(request(user_needs: "editor")).to be_inside_government_related
        expect(request(user_needs: "managing_editor")).to be_inside_government_related
        expect(request(user_needs: "other")).to_not be_inside_government_related
      end

      it "defines the formatted version" do
        expect(request(user_needs: "writer").formatted_user_needs).
          to eq("writer - can create content")
        expect(request(user_needs: "editor").formatted_user_needs).
          to eq("editor - can create, review and publish content")
      end
    end
  end
end
