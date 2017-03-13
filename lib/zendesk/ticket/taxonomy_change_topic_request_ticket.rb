require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class TaxonomyChangeTopicRequestTicket < ZendeskTicket
      def subject
        "Taxonomy change topic request - \"#{@request.title}\""
      end

      def tags
        super + ["taxonomy_change_topic_request"]
      end

    protected

      def comment_snippets
        [
          LabelledSnippet.new(on: @request, field: :formatted_type_of_change, label: "Type of change"),
          LabelledSnippet.new(on: @request, field: :title, label: "Requested topic"),
          LabelledSnippet.new(on: @request, field: :details, label: "Details of changes"),
          LabelledSnippet.new(on: @request, field: :reasons, label: "Reasons for changes"),
        ]
      end
    end
  end
end
