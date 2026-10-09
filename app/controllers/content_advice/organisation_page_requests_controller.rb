# frozen_string_literal: true

module ContentAdvice
  class OrganisationPageRequestsController < RequestsController
    def new_request
      Support::Requests::ContentAdvice::OrganisationPageRequest.new
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end

    def parse_request_from_params
      Support::Requests::ContentAdvice::OrganisationPageRequest.new(organisation_page_request_params)
    end

    def organisation_page_request_params
      params.require(:support_requests_content_advice_organisation_page_request).permit(
        :organisation_name,
        :organisation_abbreviation,
        :logo_type,
        :sis_logo_format,
        :plain_text_logo_format,
        :gcs_exemption,
        :parent_organisation,
        :organisation_type,
        :organisation_status,
        :exempt_from_govuk,
        :associated_organisations,
        :alternative_format_email,
        :govuk_lead_name,
        :govuk_lead_email,
        :additional_info,
        :deadline,
        requester_attributes: %i[email name collaborator_emails],
        time_constraint_attributes: %i[needed_by_date needed_by_day needed_by_month needed_by_year time_constraint_reason],
      )
    end
  end
end
