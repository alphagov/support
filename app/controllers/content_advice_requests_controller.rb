require 'zendesk/ticket/content_advice_request_ticket'
require 'support/requests/content_advice_request'

class ContentAdviceRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    ContentAdviceRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentAdviceRequestTicket
  end

  def parse_request_from_params
    ContentAdviceRequest.new(content_advice_request_params)
  end

  def content_advice_request_params
    params.require(:support_requests_content_advice_request).permit(
      :title, :details, :urls, :contact_number,
      requester_attributes: [:email, :name, :collaborator_emails],
      time_constraint_attributes: [:needed_by_date, :time_constraint_reason],
    ).to_h
  end
end
