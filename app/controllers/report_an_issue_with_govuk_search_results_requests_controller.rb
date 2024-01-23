class ReportAnIssueWithGovukSearchResultsRequestsController < RequestsController
protected

  def new_request
    Support::Requests::ReportAnIssueWithGovukSearchResultsRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ReportAnIssueWithGovukSearchResultsRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ReportAnIssueWithGovukSearchResultsRequest.new(request_params)
  end

  def request_params
    params.require(:support_requests_report_an_issue_with_govuk_search_results_request).permit(
      :search_query,
      :results_problem,
      :change_requested,
      :change_justification,
    ).to_h
  end
end
