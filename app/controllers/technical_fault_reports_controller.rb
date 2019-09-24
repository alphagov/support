class TechnicalFaultReportsController < RequestsController
protected

  def new_request
    Support::Requests::TechnicalFaultReport.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TechnicalFaultReportTicket
  end

  def parse_request_from_params
    Support::Requests::TechnicalFaultReport.new(technical_fault_report_params)
  end

  def technical_fault_report_params
    params.require(:support_requests_technical_fault_report).permit(
      :fault_context, :fault_specifics, :actions_leading_to_problem,
      :what_happened, :what_should_have_happened,
      requester_attributes: %i[email name collaborator_emails],
      fault_context_attributes: %i[name id inside_government_related]
    ).to_h
  end
end
