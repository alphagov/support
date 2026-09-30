# frozen_string_literal: true

module ContentAdvice
  class ShortUrlRequestsController < RequestsController
    before_action :use_design_system

    def use_design_system
      @use_design_system = true
    end

    def new_request
      Support::Requests::ContentAdvice::ShortUrlRequest.new
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::ShortUrlRequest.new(short_url_request_params)
    end

    def short_url_request_params
      params.require(:support_requests_content_advice_short_url_request).permit(
        :from_url,
        :to_url,
        :reason,
        :gov_gateway_number,
        :email,
        :identity_proof,
      ).to_h
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end
  end
end
