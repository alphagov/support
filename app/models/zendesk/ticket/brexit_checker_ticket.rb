module Zendesk
  module Ticket
    class BrexitCheckerTicket < Zendesk::ZendeskTicket
      def subject
        "Get ready for Brexit checker"
      end

      def tags
        super << "brexit_checker"
      end

    private

      def comment_snippets
        fields.map do |field|
          Zendesk::LabelledSnippet.new(on: @request, field: field)
        end
      end

      def fields
        %w(action_to_change
           description_of_change
           new_action_users
           new_action_title
           new_action_consequence
           new_action_service_link
           new_action_guidance_link
           new_action_lead_time
           new_action_deadline
           new_action_comments
           new_action_priority)
      end
    end
  end
end
