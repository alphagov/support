require 'zendesk/ticket/analytics_request_ticket'
require 'support/requests/analytics_request'

class AnalyticsRequestsController <  RequestsController
  include Support::Requests

  protected
  def new_request
    AnalyticsRequest.new(requester: Requester.new, needed_report: Support::GDS::NeededReport.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::AnalyticsRequestTicket
  end

  def parse_request_from_params
    AnalyticsRequest.new(params[:support_requests_analytics_request])
  end
end