module Zendesk
  module Ticket
    class ContentChangeRequestTicket < Zendesk::ZendeskTicket
      TICKET_FORM_ID = 7_949_329_694_108

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

      def custom_fields
        fields = [
          CustomField.set(id: 7_948_652_819_356, input: @request.reason_for_change),
          CustomField.set(id: 7_949_106_580_380, input: @request.subject_area),
        ]
        fields << CustomField.set(id: 7_949_136_091_548, input: needed_by_date) if needed_by_date
        fields << CustomField.set(id: 7_949_152_975_772, input: not_before_date) if not_before_date
        fields << CustomField.set(id: 8_250_061_570_844, input: needed_by_time) if needed_by_time
        fields << CustomField.set(id: 8_250_075_489_052, input: not_before_time) if not_before_time

        fields
      end

    protected

      def comment_snippets
        snippets = [
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
        ]
        if time_constraint_reason
          snippets << Zendesk::LabelledSnippet.new(
            on: self,
            field: :time_constraint_reason,
            label: "Reason for time constraint",
          )
        end

        snippets
      end
    end
  end
end
