require 'zendesk/ticket/remove_user_request_ticket'
require 'support/requests/remove_user_request'
require 'support/requests/time_constraint'

class RemoveUserRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    RemoveUserRequest.new(time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::RemoveUserRequestTicket
  end

  def parse_request_from_params
    RemoveUserRequest.new(params[:support_requests_remove_user_request])
  end
end
