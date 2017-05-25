module Zendesk
  module Ticket
    class RemoveUserRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Remove user"
      end

      def tags
        super + ["remove_user"]
      end

      protected
      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request, field: :user_name),
          Zendesk::LabelledSnippet.new(on: @request, field: :user_email),
          Zendesk::LabelledSnippet.new(on: @request, field: :reason_for_removal)
        ]
      end
    end
  end
end
