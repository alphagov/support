require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class CreateOrChangeUserRequestTicket < ZendeskTicket
      def subject
        @request.formatted_action
      end

      def tags
        super + [@request.action] + inside_government_tag_if_needed
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request,                field: :formatted_action,
                                                           label: "Action"),
          LabelledSnippet.new(on: @request,                field: :formatted_user_needs,
                                                           label: "User needs"),
          LabelledSnippet.new(on: @request.requested_user, field: :name,
                                                           label: "Requested user's name"),
          LabelledSnippet.new(on: @request.requested_user, field: :email,
                                                           label: "Requested user's email"),
          LabelledSnippet.new(on: @request.requested_user, field: :job,
                                                           label: "Requested user's job title"),
          LabelledSnippet.new(on: @request.requested_user, field: :phone,
                                                           label: "Requested user's phone number"),
          LabelledSnippet.new(on: @request,                field: :additional_comments)
        ]
      end
    end
  end
end
