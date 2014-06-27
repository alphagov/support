require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class ContentAdviceRequestTicket < ZendeskTicket
      def subject
        if (@request.title.nil? or @request.title.empty?)
          "Advice on content"
        else
          "#{@request.title} - Advice on content"
        end
      end

      def tags
        super + ["dept_content_advice"]
      end

      protected
      def comment_snippets
        [
          request_label(field: :formatted_nature_of_request,
                        label: "Nature of the request"),
          request_label(field: :details),
          # LabelledSnippet.new(on: @request, field: :details)
        ]
      end
    end
  end
end
