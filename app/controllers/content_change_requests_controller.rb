require 'zendesk/ticket/content_change_request_ticket'
require 'support/requests/content_change_request'

class ContentChangeRequestsController < RequestsController
  protected
  def new_request
    Support::Requests::ContentChangeRequest.new(requester: Requester.new, time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentChangeRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ContentChangeRequest.new(params[:support_requests_content_change_request])
  end
end
