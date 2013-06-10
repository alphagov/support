require 'zendesk/ticket/content_change_request_ticket'
require 'support/requests/requester'
require 'support/requests/content_change_request'
require 'support/requests/time_constraint'

class ContentChangeRequestsController < RequestsController
  protected
  def new_request
    Support::Requests::ContentChangeRequest.new(requester: Support::Requests::Requester.new,
                                                time_constraint: Support::Requests::TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentChangeRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ContentChangeRequest.new(params[:support_requests_content_change_request])
  end
end
