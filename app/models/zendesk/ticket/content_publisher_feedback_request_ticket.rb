module Zendesk
  module Ticket
    class ContentPublisherFeedbackRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Content Publisher feedback request"
      end

      def tags
        super + %w[content_publisher_feedback_request]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request, field: :feedback_type, label: "Your feedback is about"),
          Zendesk::LabelledSnippet.new(on: @request, field: :feedback_details, label: "Tell us a bit more"),
          Zendesk::LabelledSnippet.new(on: @request, field: :impact_on_work, label: "What's the impact on your work if we don't do anything about it?"),
        ]
      end
    end
  end
end
