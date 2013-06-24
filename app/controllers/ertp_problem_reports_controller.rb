require 'zendesk/ticket/ertp_problem_report_ticket'
require 'support/requests/ertp_problem_report'

class ErtpProblemReportsController < RequestsController
  include Support::Requests

  protected
  def new_request
    ErtpProblemReport.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ErtpProblemReportTicket
  end

  def parse_request_from_params
    ErtpProblemReport.new(params[:support_requests_ertp_problem_report])
  end
end
