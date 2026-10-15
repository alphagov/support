# frozen_string_literal: true

module ContentAdvice
  class ContentDesignHelpRequestsController < RequestsController
    def new_request
      Support::Requests::ContentAdvice::ContentDesignHelpRequest.new
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::ContentDesignHelpRequest.new(content_design_help_request_params)
    end

    def content_design_help_request_params
      params.require(:support_requests_content_advice_content_design_help_request).permit(
        :title,
        :advice_needed,
        :deadline,
        requester_attributes: %i[email name collaborator_emails],
        time_constraint_attributes: %i[needed_by_date needed_by_day needed_by_month needed_by_year time_constraint_reason],
      )
    end
  end
end
