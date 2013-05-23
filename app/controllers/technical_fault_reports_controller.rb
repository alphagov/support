require 'zendesk/ticket/technical_fault_report_ticket'
require 'support/requests/technical_fault_report'

class TechnicalFaultReportsController <  RequestsController
  protected
  def new_request
    Support::Requests::TechnicalFaultReport.new(requester: Requester.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TechnicalFaultReportTicket
  end

  def parse_request_from_params
    Support::Requests::TechnicalFaultReport.new(params[:support_requests_technical_fault_report])
  end
end