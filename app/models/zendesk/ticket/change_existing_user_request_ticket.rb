module Zendesk
  module Ticket
    class ChangeExistingUserRequestTicket < Zendesk::ZendeskTicket
      def subject
        @request.formatted_action
      end

      def tags
        super + [@request.action] + inside_government_tag_if_needed
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_action,
            label: "Action",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.requested_user,
            field: :name,
            label: "Requested user's name",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.requested_user,
            field: :email,
            label: "Requested user's email",
          ),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments),
        ]
      end
    end
  end
end
