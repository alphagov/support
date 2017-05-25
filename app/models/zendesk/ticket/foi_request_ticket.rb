require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class FoiRequestTicket < ZendeskTicket
      def subject
        "FOI"
      end

      def tags
        ["public_form", "foi_request"]
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request.requester, field: :name),
          LabelledSnippet.new(on: @request.requester, field: :email),
          request_label(field: :details)
        ]
      end
    end
  end
end
