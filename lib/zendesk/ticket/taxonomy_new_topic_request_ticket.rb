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
          LabelledSnippet.new(on: @request, field: :title, label: "Requested topic"),
          LabelledSnippet.new(on: @request, field: :url, label: "URL of new topic"),
          LabelledSnippet.new(on: @request, field: :details, label: "Evidence"),
          LabelledSnippet.new(on: @request, field: :parent, label: "Parent topic"),
        ]
      end
    end
  end
end
