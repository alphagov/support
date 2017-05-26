module Zendesk
  module Ticket
    class FoiRequestTicket < Zendesk::ZendeskTicket
      def subject
        "FOI"
      end

      def tags
        %w(public_form foi_request)
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request.requester, field: :name),
          Zendesk::LabelledSnippet.new(on: @request.requester, field: :email),
          request_label(field: :details)
        ]
      end
    end
  end
end
