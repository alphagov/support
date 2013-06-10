require 'zendesk/ticket/general_request_ticket'
require 'support/requests/general_request'

class GeneralRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    GeneralRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::GeneralRequestTicket
  end

  def parse_request_from_params
    user_request = GeneralRequest.new(params[:support_requests_general_request])
    user_request.user_agent = request.user_agent
    user_request
  end
end