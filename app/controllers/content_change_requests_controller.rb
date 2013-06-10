require 'zendesk/ticket/content_change_request_ticket'
require 'support/requests/requester'
require 'support/requests/content_change_request'
require 'support/requests/time_constraint'

class ContentChangeRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    ContentChangeRequest.new(requester: Requester.new, time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentChangeRequestTicket
  end

  def parse_request_from_params
    ContentChangeRequest.new(params[:support_requests_content_change_request])
  end
end
