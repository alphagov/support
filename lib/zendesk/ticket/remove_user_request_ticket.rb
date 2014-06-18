require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class RemoveUserRequestTicket < ZendeskTicket
      def subject
        "Remove user"
      end

      def tags
        super + ["remove_user"]
      end

      protected
      def comment_snippets
        [
          LabelledSnippet.new(on: @request, field: :user_name),
          LabelledSnippet.new(on: @request, field: :user_email),
          LabelledSnippet.new(on: @request, field: :reason_for_removal)
        ]
      end
    end
  end
end
