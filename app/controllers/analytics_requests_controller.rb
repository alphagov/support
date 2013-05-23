require 'zendesk/ticket/analytics_request_ticket'

class AnalyticsRequestsController <  RequestsController
  protected
  def new_request
    AnalyticsRequest.new(requester: Requester.new, needed_report: NeededReport.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::AnalyticsRequestTicket
  end

  def parse_request_from_params
    AnalyticsRequest.new(params[:analytics_request])
  end
end