require 'spec_helper'
require 'active_model/model'
require 'support/gds/with_request_context'

module Support
  module GDS
    class TestModelWithRequestContext
      include ActiveModel::Model
      include WithRequestContext
    end

    describe TestModelWithRequestContext do
      it { should validate_presence_of(:request_context) }
      it { should allow_value("mainstream").for(:request_context) }
      it { should allow_value("inside_government").for(:request_context) }
      it { should allow_value("detailed_guidance").for(:request_context) }
      it { should_not allow_value("xxx").for(:request_context) }

      it "knows if it's related to inside government or not" do
        expect(TestModelWithRequestContext.new(request_context: "inside_government")).to be_inside_government_related
        expect(TestModelWithRequestContext.new(request_context: "detailed_guidance")).to be_inside_government_related
        expect(TestModelWithRequestContext.new(request_context: "mainstream")).to_not be_inside_government_related
      end

      it "defines the formatted version" do
        expect(TestModelWithRequestContext.new(request_context: "inside_government").formatted_request_context).to eq("Departments and policy")
      end
    end
  end
end
