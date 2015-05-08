require 'zendesk/ticket/foi_request_ticket'
require 'support/requests/foi_request'

class FoiRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    FoiRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::FoiRequestTicket
  end

  def parse_request_from_params
    FoiRequest.new(foi_request_params)
  end

  def set_requester_on(request)
    request.requester = Support::Requests::Requester.new(foi_request_params[:requester])
  end

  def foi_request_params
    params.require(:foi_request).permit(
      :details, { requester: [:email, :name] }
    )
  end
end
