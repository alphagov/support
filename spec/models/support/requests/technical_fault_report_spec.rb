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
      it { should allow_value("content_data").for(:fault_context) }
      it { should_not allow_value("xxx").for(:fault_context) }

      describe "#formatted_fault_context" do
        it "returns the human readable name for the chosen context" do
          report = described_class.new(fault_context: "do_not_know")
          expect(report.formatted_fault_context).to eq "Other / do not know"
        end
      end

      describe "#fault_subject" do
        it "returns a subject to be used for the Zendesk ticket" do
          report = described_class.new(fault_context: "content_data")
          expect(report.fault_subject).to eq "Technical fault with Content Data"
        end

        it "returns a special subject if 'Do not know' was selected" do
          report = described_class.new(fault_context: "do_not_know")
          expect(report.fault_subject).to eq "Technical fault report"
        end
      end
    end
  end
end
