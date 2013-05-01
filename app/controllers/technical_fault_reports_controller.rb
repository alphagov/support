require 'technical_fault_report_zendesk_ticket'

class TechnicalFaultReportsController <  RequestsController
  protected
  def new_request
    TechnicalFaultReport.new(requester: Requester.new, fault_context: UserFacingComponent.new)
  end

  def zendesk_ticket_class
    TechnicalFaultReportZendeskTicket
  end

  def parse_request_from_params
    TechnicalFaultReport.new(params[:technical_fault_report])
  end
end