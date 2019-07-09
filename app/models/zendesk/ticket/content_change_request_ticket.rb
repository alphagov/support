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
          Zendesk::LabelledSnippet.new(on: @request,                 field: :url,
                                                            label: "URL of content to be changed"),
          Zendesk::LabelledSnippet.new(on: @request,                 field: :related_urls,
                                                            label: "Related URLs"),
          Zendesk::LabelledSnippet.new(on: @request,                 field: :details_of_change,
                                                            label: "Details of what should be added, amended or removed"),
        ]
      end
    end
  end
end
