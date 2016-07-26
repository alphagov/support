require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class AnalyticsRequestTicket < ZendeskTicket
      def subject
        "Request for analytics"
      end

      def tags
        super + ["analytics"]
      end

      protected
      def comment_snippets
        [
          LabelledSnippet.new(on: @request.needed_report, field: :reporting_period),
          LabelledSnippet.new(on: @request.needed_report, field: :pages_or_sections,
                                                          label: "Requested pages/sections"),
          LabelledSnippet.new(on: @request,               field: :justification_for_needing_report),
          LabelledSnippet.new(on: @request.needed_report, field: :non_standard_requirements,
                                                          label: "More detailed analysis needed?"),
          LabelledSnippet.new(on: @request.needed_report, field: :formatted_frequency,
                                                          label: "Reporting frequency"),
          LabelledSnippet.new(on: @request.needed_report, field: :formatted_format,
                                                          label: "Report format"),
        ]
      end
    end
  end
end
