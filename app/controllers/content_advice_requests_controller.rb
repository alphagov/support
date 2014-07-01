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
    ContentAdviceRequest.new(params[:support_requests_content_advice_request])
  end
end
