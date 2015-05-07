require 'zendesk/ticket/analytics_request_ticket'
require 'support/requests/analytics_request'

class AnalyticsRequestsController <  RequestsController
  include Support::Requests

  protected
  def new_request
    AnalyticsRequest.new(needed_report: Support::GDS::NeededReport.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::AnalyticsRequestTicket
  end

  def parse_request_from_params
    AnalyticsRequest.new(analytics_request_params)
  end

  def analytics_request_params
    params.require(:support_requests_analytics_request).permit(
      :justification_for_needing_report,
      :request_context,
      requester_attributes: [:email, :name, :collaborator_emails],
      needed_report_attributes: [
        :reporting_period_start,
        :reporting_period_end,
        :pages_or_sections,
        :non_standard_requirements,
        :frequency,
        :format
      ],
    )
  end
end
