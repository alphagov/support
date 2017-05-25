require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class NamedContactTicket < ZendeskTicket
      def subject
        suffix = @request.govuk_link_path.nil? ? "" : " about #{@request.govuk_link_path}"
        "Named contact" + suffix
      end

      def tags
        [ "public_form", "named_contact"]
      end

      def requester_details
        "#{@requester.name} <#{@requester.email}>"
      end

      def javascript_enabled
        @request.javascript_enabled.to_s
      end

      def user_agent
        @request.user_agent || "Unknown"
      end

      def referrer
        @request.referrer || "Unknown"
      end

      protected
      def comment_snippets
        [
          LabelledSnippet.new(on: self, field: :requester_details, label: "Requester"),
          request_label(field: :details),
          request_label(field: :link),
          LabelledSnippet.new(on: self, field: :referrer),
          LabelledSnippet.new(on: self, field: :user_agent),
          LabelledSnippet.new(on: self, field: :javascript_enabled, label: "JavaScript Enabled")
        ]
      end
    end
  end
end
