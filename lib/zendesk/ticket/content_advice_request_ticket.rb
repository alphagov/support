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
          request_label(field: :urls,
                        label: "Relevant URLs"),
          request_label(field: :response_needed_by_date,
                        label: "Date needed by"),
          request_label(field: :reason_for_deadline),
          request_label(field: :contact_number),
        ]
      end
    end
  end
end
