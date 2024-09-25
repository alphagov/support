module Zendesk
  module Ticket
    class CreateNewUserRequestTicket < Zendesk::ZendeskTicket
      def subject
        @request.formatted_action
      end

      def tags
        super + [@request.action]
      end

      def collaborator_emails
        super + [@request.email]
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
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_whitehall_training_option,
            label: "Access to Whitehall Publisher",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_access_to_other_publishing_apps_option,
            label: "Access to other publishing apps",
          ),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments),
        ]
      end
    end
  end
end
