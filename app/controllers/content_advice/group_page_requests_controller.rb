# frozen_string_literal: true

module ContentAdvice
  class GroupPageRequestsController < RequestsController
    def new_request
      Support::Requests::ContentAdvice::GroupPageRequest.new
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::GroupPageRequest.new(group_page_request_params)
    end

    def group_page_request_params
      params.require(:support_requests_content_advice_group_page_request).permit(
        :group_name,
        :purpose,
        :user_needs_evidence,
        :contact_reason,
        :additional_info,
        :deadline,
        requester_attributes: %i[email name collaborator_emails],
        time_constraint_attributes: %i[needed_by_date needed_by_day needed_by_month needed_by_year time_constraint_reason],
      )
    end
  end
end
