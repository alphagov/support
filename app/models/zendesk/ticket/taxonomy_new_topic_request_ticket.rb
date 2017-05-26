module Zendesk
  module Ticket
    class TaxonomyNewTopicRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Taxonomy new topic request - \"#{@request.title}\""
      end

      def tags
        super + ["taxonomy_new_topic_request"]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request, field: :title, label: "Requested topic"),
          Zendesk::LabelledSnippet.new(on: @request, field: :url, label: "URL of new topic"),
          Zendesk::LabelledSnippet.new(on: @request, field: :details, label: "Evidence"),
          Zendesk::LabelledSnippet.new(on: @request, field: :parent, label: "Parent topic"),
        ]
      end
    end
  end
end
