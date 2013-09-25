require 'zendesk/ticket/problem_report_ticket'
require 'support/requests/problem_report'

class AnonymousFeedback::ProblemReportsController < RequestsController
  include Support::Requests

  protected
  def new_request
    ProblemReport.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ProblemReportTicket
  end

  def parse_request_from_params
    ProblemReport.new(params[:problem_report])
  end

  def set_requester_on(request)
    # this is anonymous feedback, so anonymous requester set automatically on ProblemReport
  end
end
