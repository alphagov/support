module Support
  module Requests
    class ReportAnIssueWithGovukSearchResultsRequest < Request
      attr_accessor :search_query, :results_problem, :change_requested, :change_justification, :evidence_availability

      validates :search_query, presence: true
      validates :results_problem, presence: true
      validates :evidence_availability, inclusion: { in: %w[yes no not_sure] }

      def formatted_evidence_availability
        Hash[evidence_availability_options].key(evidence_availability)
      end

      def evidence_availability_options
        [
          ["Yes – using analytics data (for example Google Analytics)", "yes"],
          ["No", "no"],
          ["Not sure", "not_sure"],
        ]
      end

      def self.label
        "Report an issue with GOV.UK search results"
      end

      def self.description
        "Report a problem or request a change to search results on GOV.UK."
      end
    end
  end
end
