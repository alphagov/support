module Zendesk
  module Ticket
    class RemoveUserRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Remove user"
      end

      def tags
        super + %w[remove_user]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: self,     field: :not_before_date),
          Zendesk::LabelledSnippet.new(on: @request, field: :user_name),
          Zendesk::LabelledSnippet.new(on: @request, field: :user_email),
          Zendesk::LabelledSnippet.new(on: @request, field: :reason_for_removal),
        ]
      end
    end
  end
end
