module Zendesk
  module Ticket
    class AccountsPermissionsAndTrainingRequestTicket < Zendesk::ZendeskTicket
      def subject
        @request.formatted_action
      end

      def tags
        super + [@request.action] + inside_government_tag_if_needed
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request,                field: :formatted_action,
                                                           label: "Action"),
          Zendesk::LabelledSnippet.new(on: @request,                field: :formatted_user_needs,
                                                           label: "User needs"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :name,
                                                           label: "Requested user's name"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :email,
                                                           label: "Requested user's email"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :job,
                                                           label: "Requested user's job title"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :phone,
                                                           label: "Requested user's phone number"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :formatted_training,
                                                           label: "Requested user's training"),
          Zendesk::LabelledSnippet.new(on: @request.requested_user, field: :other_training,
                                                           label: "Requested user's other training"),
          Zendesk::LabelledSnippet.new(on: @request,                field: :additional_comments),
        ]
      end
    end
  end
end
