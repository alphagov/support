require "rails_helper"

module Support
  module Requests
    describe TechnicalFaultReport do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:fault_context) }
      it { should validate_presence_of(:fault_specifics) }
      it { should validate_presence_of(:actions_leading_to_problem) }
      it { should validate_presence_of(:what_happened) }
      it { should validate_presence_of(:what_should_have_happened) }

      it "is Inside Government-related if the fault is caused by an Inside Government technical component" do
        expect(TechnicalFaultReport.new(fault_context: double(inside_government_related?: true))
          .inside_government_related?).to be_truthy
        expect(TechnicalFaultReport.new(fault_context: double(inside_government_related?: false))
          .inside_government_related?).to be_falsey
      end
    end
  end
end
