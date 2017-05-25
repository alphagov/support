module Zendesk
  module Ticket
    class AnalyticsRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Request for analytics"
      end

      def tags
        super + ["analytics"]
      end

      protected
      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :google_analytics_request_details,
            label: 'Google Analytics Access'
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :single_point_of_contact_request_details,
            label: 'Single Point of Contact'
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :report_request_details,
            label: 'Report Request'
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :help_request_details,
            label: 'Help'
          )
        ]
      end
    end
  end
end
