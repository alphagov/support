require 'general_request_zendesk_ticket'

class GeneralRequestsController <  ApplicationController
  def new
    @request = GeneralRequest.new(:requester => Requester.new)
    prepopulate_organisation_list
  end

  def create
    request = GeneralRequest.new(params[:general_request])
    request.user_agent = request.user_agent
    ticket = GeneralRequestZendeskTicket.new(request)

    if request.valid?
      raise_ticket(ticket)
    else
      render :new, :status => 400
    end
  end
end