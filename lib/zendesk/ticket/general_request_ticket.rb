require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class GeneralRequestTicket < ZendeskTicket
      def subject
        "Govt Agency General Issue"
      end

      def tags
        super + ["govt_agency_general"]
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request, field: :url),
          LabelledSnippet.new(on: @request, field: :user_agent),
          LabelledSnippet.new(on: @request, field: :additional)
        ]
      end
    end
  end
end