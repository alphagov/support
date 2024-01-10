module Zendesk
  module Ticket
    class CreateUserRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Create a new user account"
      end

      def tags
        super + %w[create_new_user]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: self,
            field: :subject,
            label: "Action",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :user_name,
            label: "Requested user's name",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :user_email,
            label: "Requested user's email",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :other_apps,
            label: "Other apps",
          ),
        ]
      end
    end
  end
end
