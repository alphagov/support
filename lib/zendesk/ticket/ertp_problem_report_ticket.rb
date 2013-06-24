require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class ErtpProblemReportTicket < ZendeskTicket
      def subject
        "New ERTP problem report"
      end

      def tags
        super + ["ertp_problem_report", "non_gov_uk"]
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request, field: :url),
          LabelledSnippet.new(on: @request, field: :additional)
        ]
      end
    end
  end
end
