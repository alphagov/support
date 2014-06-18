require 'zendesk/ticket/named_contact_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class LongFormContactTicket < NamedContactTicket
      def subject
        suffix = @request.govuk_link_path.nil? ? "" : " about #{@request.govuk_link_path}"
        "Anonymous contact" + suffix
      end

      def tags
        %w{anonymous_feedback public_form long_form_contact}
      end

      protected
      def comment_snippets
        [
          request_label(field: :details),
          request_label(field: :user_specified_url, label: "URL"),
          LabelledSnippet.new(on: self, field: :referrer),
          LabelledSnippet.new(on: self, field: :user_agent),
          LabelledSnippet.new(on: self, field: :javascript_enabled, label: "JavaScript Enabled")
        ]
      end
    end
  end
end
