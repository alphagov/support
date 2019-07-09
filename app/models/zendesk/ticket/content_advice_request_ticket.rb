module Zendesk
  module Ticket
    class ContentAdviceRequestTicket < Zendesk::ZendeskTicket
      def subject
        deadline_prefix = (deadline_date ? "Needed by #{deadline_date}: " : "")
        title_text = if @request.title.blank?
                       "Advice on content"
                     else
                       "#{@request.title} - Advice on content"
                     end
        deadline_prefix + title_text
      end

      def tags
        super + %w[dept_content_advice]
      end

    protected

      def comment_snippets
        [
          request_label(field: :details),
          request_label(field: :urls,
                        label: "Relevant URLs"),
          request_label(field: :contact_number),
        ]
      end

      def deadline_date
        if needed_by_date.present?
          Date.parse(needed_by_date).strftime("%-d %b")
        end
      end
    end
  end
end
