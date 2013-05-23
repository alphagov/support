require 'zendesk/ticket/content_change_request_ticket'

class ContentChangeRequestsController < RequestsController
  protected
  def new_request
    ContentChangeRequest.new(:requester => Requester.new, :time_constraint => TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentChangeRequestTicket
  end

  def parse_request_from_params
    ContentChangeRequest.new(params[:content_change_request])
  end
end
