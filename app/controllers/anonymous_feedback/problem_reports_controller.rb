require 'zendesk/ticket/problem_report_ticket'
require 'support/requests/anonymous/problem_report'

class AnonymousFeedback::ProblemReportsController < AnonymousFeedbackController
  include Support::Requests

  def index
    authorize! :read, Anonymous::ProblemReport

    if params[:path].nil? or params[:path].empty?
      respond_to do |format|
        format.html { redirect_to anonymous_feedback_problem_reports_explore_url, status: 301 }
        format.json { render json: {"errors" => ["Please set a valid 'path' parameter"] }, status: 400 }
      end
    else
      @feedback = Anonymous::ProblemReport.find_all_starting_with_path(params[:path])
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @feedback.as_json(root:false, only: [:what_wrong, :what_doing, :created_at, :url, :referrer]) }
      end
    end
  end

  protected
  def new_request
    Anonymous::ProblemReport.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ProblemReportTicket
  end

  def parse_request_from_params
    Anonymous::ProblemReport.new(params[:problem_report])
  end
end
