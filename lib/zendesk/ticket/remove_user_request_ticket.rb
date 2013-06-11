require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class RemoveUserRequestTicket < ZendeskTicket
      def subject
        "Remove user"
      end

      def tags
        super + ["remove_user"] + inside_government_tag_if_needed
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request, field: :formatted_tool_role,
                                            label: "Tool/Role"),
          LabelledSnippet.new(on: @request, field: :user_name),
          LabelledSnippet.new(on: @request, field: :user_email),
          LabelledSnippet.new(on: @request, field: :reason_for_removal)
        ]
      end
    end
  end
end
