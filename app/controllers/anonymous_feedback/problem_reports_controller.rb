require 'zendesk/ticket/problem_report_ticket'
require 'support/requests/anonymous/problem_report'

class AnonymousFeedback::ProblemReportsController < AnonymousFeedbackController
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
end
