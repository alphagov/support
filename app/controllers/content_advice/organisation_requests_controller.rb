# frozen_string_literal: true

module ContentAdvice
  class OrganisationRequestsController < RequestsController
    before_action :use_design_system

    def use_design_system
      @use_design_system = true
    end

    def new_request
      Support::Requests::ContentAdvice::OrganisationRequest.new
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::OrganisationRequest.new(organisation_request_params)
    end

    def organisation_request_params
      params.require(:support_requests_content_advice_organisation_request).permit(
        :org_name,
      ).to_h
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end
  end
end
