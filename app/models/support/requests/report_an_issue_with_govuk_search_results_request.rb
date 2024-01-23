module Support
  module Requests
    class ReportAnIssueWithGovukSearchResultsRequest < Request
      attr_accessor :search_query, :results_problem, :change_requested, :change_justification

      validates :search_query, presence: true
      validates :results_problem, presence: true
      validates :change_requested, presence: true
      validates :change_justification, presence: true

      def self.label
        "Report an issue with GOV.UK search results"
      end

      def self.description
        "Report a problem with specific search results from the new GOV.UK search engine."
      end
    end
  end
end
