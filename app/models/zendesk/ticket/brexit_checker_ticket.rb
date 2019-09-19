module Zendesk
  module Ticket
    class BrexitCheckerTicket < Zendesk::ZendeskTicket
      def subject
        "Get ready for Brexit checker"
      end

    private

      def comment_snippets
        fields.map do |field|
          Zendesk::LabelledSnippet.new(on: @request, field: field)
        end
      end

      def fields
        %w(action_to_change description_of_change)
      end
    end
  end
end
