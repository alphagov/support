require "rails_helper"

module Support
  module Requests
    describe ReportAnIssueWithGovukSearchResultsRequest do
      it { should validate_presence_of(:search_query) }
      it { should validate_presence_of(:results_problem) }
      it { should validate_presence_of(:change_requested) }
      it { should validate_presence_of(:change_justification) }
    end
  end
end
