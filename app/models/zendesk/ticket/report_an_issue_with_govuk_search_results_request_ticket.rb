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
          Zendesk::LabelledSnippet.new(on: @request, field: :search_query, label: "What search query did you use?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :results_problem, label: "What is the problem with the search results?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :change_requested, label: "What change do you want to make to the search results?"),
          Zendesk::LabelledSnippet.new(on: @request, field: :change_justification, label: "Why is this change necessary?"),
        ]
      end
    end
  end
end
