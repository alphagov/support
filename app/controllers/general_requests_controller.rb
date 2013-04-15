require 'general_request_zendesk_ticket'

class GeneralRequestsController <  RequestsController
  protected
  def request_class
    GeneralRequest
  end

  def new_request
    request_class.new(:requester => Requester.new)
  end

  def zendesk_ticket_class
    GeneralRequestZendeskTicket
  end

  def parse_request_from_params
    user_request = request_class.new(params[:general_request])
    user_request.user_agent = request.user_agent
    user_request
  end
end