require 'general_request_zendesk_ticket'

class GeneralRequestsController <  ApplicationController

  def new_request
    GeneralRequest.new(:requester => Requester.new)
  end

  def zendesk_ticket_class
    GeneralRequestZendeskTicket
  end

  def parse_request_from_params
    user_request = GeneralRequest.new(params[:general_request])
    user_request.user_agent = request.user_agent
    user_request
  end
end