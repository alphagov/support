require 'zendesk/ticket/remove_user_request_ticket'
require 'support/requests/remove_user_request'

class RemoveUserRequestsController < RequestsController
  protected
  def new_request
    Support::Requests::RemoveUserRequest.new(time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::RemoveUserRequestTicket
  end

  def parse_request_from_params
    Support::Requests::RemoveUserRequest.new(params[:support_requests_remove_user_request])
  end
end
