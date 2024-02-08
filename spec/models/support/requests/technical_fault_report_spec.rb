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

      it "sets the fault context based on fault context attributes" do
        report = described_class.new(fault_context_attributes: { "name" => "content_data" })
        expect(report.fault_context.name).to eq "Content Data"
      end
    end
  end
end
