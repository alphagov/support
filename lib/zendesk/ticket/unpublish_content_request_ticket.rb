require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class UnpublishContentRequestTicket < ZendeskTicket
      def subject
        "#{@request.formatted_reason_for_unpublishing} - Unpublish content request"
      end

      def tags
        super + ["unpublish_content", "inside_government", @request.reason_for_unpublishing]
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request, field: :urls, label: "URL of content to be unpublished"),
          LabelledSnippet.new(on: @request, field: :formatted_reason_for_unpublishing, label: "Reason"),
          LabelledSnippet.new(on: @request, field: :further_explanation)
        ]
      end
    end
  end
end
