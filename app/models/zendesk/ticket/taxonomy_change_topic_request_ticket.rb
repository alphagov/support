module Zendesk
  module Ticket
    class TaxonomyChangeTopicRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Taxonomy change topic request - \"#{@request.title}\""
      end

      def tags
        super + ["taxonomy_change_topic_request"]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request, field: :formatted_type_of_change, label: "Type of change"),
          Zendesk::LabelledSnippet.new(on: @request, field: :title, label: "Requested topic"),
          Zendesk::LabelledSnippet.new(on: @request, field: :details, label: "Details of changes"),
          Zendesk::LabelledSnippet.new(on: @request, field: :reasons, label: "Reasons for changes"),
        ]
      end
    end
  end
end
