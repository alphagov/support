require 'analytics_request_zendesk_ticket'

class AnalyticsRequestsController <  RequestsController
  protected
  def request_class
    AnalyticsRequest
  end

  def new_request
    request_class.new(requester: Requester.new, needed_report: NeededReport.new)
  end

  def zendesk_ticket_class
    AnalyticsRequestZendeskTicket
  end

  def parse_request_from_params
    request_class.new(params[:analytics_request])
  end
end