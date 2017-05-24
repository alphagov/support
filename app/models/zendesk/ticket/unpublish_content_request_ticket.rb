module Zendesk
  module Ticket
    class UnpublishContentRequestTicket < Zendesk::ZendeskTicket
      def subject
        "#{@request.formatted_reason_for_unpublishing} - Unpublish content request"
      end

      def tags
        super + ["unpublish_content", "inside_government", @request.reason_for_unpublishing]
      end

    protected

      def comment_snippets
        labels = [
          request_label(field: :urls, label: "URL of content to be unpublished"),
          request_label(field: :formatted_reason_for_unpublishing, label: "Reason"),
          request_label(field: :further_explanation),
        ]
        if @request.another_page_involved?
          labels += [
            request_label(field: :redirect_url, label: "Redirect URL"),
            request_label(field: :formatted_automatic_redirect, label: "Automatic redirect?")
          ]
        end
        labels
      end
    end
  end
end
