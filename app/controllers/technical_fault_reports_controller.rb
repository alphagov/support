require 'zendesk/ticket/technical_fault_report_ticket'
require 'support/requests/requester'
require 'support/requests/technical_fault_report'

class TechnicalFaultReportsController <  RequestsController
  include Support::Requests

  protected
  def new_request
    TechnicalFaultReport.new(requester: Requester.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TechnicalFaultReportTicket
  end

  def parse_request_from_params
    TechnicalFaultReport.new(params[:support_requests_technical_fault_report])
  end
end