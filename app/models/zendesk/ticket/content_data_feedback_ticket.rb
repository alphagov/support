module Zendesk
  module Ticket
    class ContentDataFeedbackTicket < Zendesk::ZendeskTicket
      def subject
        "Content Data feedback"
      end

      def tags
        super + %w[content_data_feedback]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :feedback_type,
            label: "Your feedback is about",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :feedback_details,
            label: "Tell us a bit more",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :impact_on_work,
            label: "What's the impact on your work if we don't do anything about it?",
          ),
        ]
      end
    end
  end
end
