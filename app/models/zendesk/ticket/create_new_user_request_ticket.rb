module Zendesk
  module Ticket
    class CreateNewUserRequestTicket < Zendesk::ZendeskTicket
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
            on: @request,
            field: :name,
            label: "Requested user's name",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :email,
            label: "Requested user's email",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :organisation,
            label: "Organisation",
          ),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments),
        ]
      end
    end
  end
end
