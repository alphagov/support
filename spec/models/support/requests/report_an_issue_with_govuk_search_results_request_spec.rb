require "rails_helper"

module Support
  module Requests
    describe ReportAnIssueWithGovukSearchResultsRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:search_query) }
      it { should validate_presence_of(:results_problem) }

      it { should allow_value("yes").for(:evidence_availability) }
      it { should allow_value("no").for(:evidence_availability) }
      it { should allow_value("not_sure").for(:evidence_availability) }
      it { should_not allow_value("xxx").for(:evidence_availability) }

      it "provides evidence_availability choices" do
        expect(request.evidence_availability_options).to_not be_empty
      end

      it "provides formatted evidence_availability" do
        expect(request(evidence_availability: "not_sure").formatted_evidence_availability).to eq("Not sure")
      end
    end
  end
end
