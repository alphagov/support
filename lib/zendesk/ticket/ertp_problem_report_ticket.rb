require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class ErtpProblemReportTicket < ZendeskTicket
      def subject
        "#{@request.incident_stage} - ERTP problem report"
      end

      def tags
        super + ["ertp_problem_report", "non_gov_uk"]
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request, field: :control_center_ticket_number, label: "Control Center ticket number"),
          LabelledSnippet.new(on: @request, field: :local_authority_impacted, label: "Local authority"),
          LabelledSnippet.new(on: @request, field: :incident_stage),
          LabelledSnippet.new(on: @request, field: :formatted_are_multiple_local_authorities_impacted, label: "Multiple local authorities impacted?"),
          LabelledSnippet.new(on: @request, field: :description, label: "Problem description"),
          LabelledSnippet.new(on: @request, field: :investigation, label: "Details of the investigation"),
          LabelledSnippet.new(on: @request, field: :additional)
        ]
      end
    end
  end
end
