module Zendesk
  module Ticket
    class ContentChangeRequestTicket < Zendesk::ZendeskTicket
      def subject
        if @request.title.present?
          "#{@request.title} - Content change request"
        else
          "Content change request"
        end
      end

      def tags
        super + %w[content_amend]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :reason_for_change,
            label: "Reason for change request",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :subject_area,
            label: "Subject area",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :url,
            label: "URLs to be changed",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :details_of_change,
            label: "Details of what should be added, amended or removed",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :why_is_change_needed,
            label: "Why is this change needed",
          ),
        ]
      end
    end
  end
end
