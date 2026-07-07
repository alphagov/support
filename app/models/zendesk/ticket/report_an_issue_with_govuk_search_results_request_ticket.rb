module Zendesk
  module Ticket
    class ReportAnIssueWithGovukSearchResultsRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Report an issue with GOV.UK search results"
      end

      def tags
        super + %w[site_search]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request, field: :search_query, label: "What search queries are not working well?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :results_problem, label: "What is the problem with the search results?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :change_requested, label: "Which pages are showing incorrectly and how should they be changed?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :change_justification, label: "Why is this change necessary?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :formatted_evidence_availability, label: "Is there evidence that users are searching for these queries?"),
        ]
      end
    end
  end
end
