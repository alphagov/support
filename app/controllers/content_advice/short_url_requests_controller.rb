# frozen_string_literal: true

module ContentAdvice
  class ShortUrlRequestsController < RequestsController
    def new_request
      Support::Requests::ContentAdvice::ShortUrlRequest.new
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::ShortUrlRequest.new(short_url_request_params)
    end

    def short_url_request_params
      params.require(:support_requests_content_advice_short_url_request).permit(
        :title,
        :destination_page,
        :reason,
        :usage,
        :marketing_message,
        :organisations_using_url,
        :additional_info,
        :deadline,
        requester_attributes: %i[email name collaborator_emails],
        time_constraint_attributes: %i[needed_by_date needed_by_day needed_by_month needed_by_year time_constraint_reason],
      )
    end
  end
end
