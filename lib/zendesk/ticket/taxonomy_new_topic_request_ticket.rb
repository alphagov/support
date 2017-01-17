require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class TaxonomyNewTopicRequestTicket < ZendeskTicket
      def subject
        "Taxonomy new topic request - \"#{@request.title}\""
      end

      def tags
        super + ["taxonomy_new_topic_request"]
      end

    protected

      def comment_snippets
        [
          request_label(field: :url),
          request_label(field: :details),
          request_label(field: :parent),
        ]
      end
    end
  end
end
