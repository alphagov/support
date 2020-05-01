module Zendesk
  module Ticket
    class NamedContactTicket < Zendesk::ZendeskTicket
      def subject
        suffix = @request.govuk_link_path.nil? ? "" : " about #{@request.govuk_link_path}"
        "Named contact" + suffix
      end

      def tags
        %w[public_form named_contact]
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
          Zendesk::LabelledSnippet.new(on: self, field: :requester_details, label: "Requester"),
          request_label(field: :details),
          request_label(field: :link),
          Zendesk::LabelledSnippet.new(on: self, field: :referrer),
          Zendesk::LabelledSnippet.new(on: self, field: :user_agent),
          Zendesk::LabelledSnippet.new(on: self, field: :javascript_enabled, label: "JavaScript Enabled"),
        ]
      end
    end
  end
end
