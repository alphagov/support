require "rails_helper"

module Zendesk
  module Ticket
    describe ReportAnIssueWithGovukSearchResultsRequestTicket do
      subject { described_class.new(double(requester: nil)) }

      its(:tags) { should include("site_search") }
    end
  end
end
