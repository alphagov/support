require 'zendesk/ticket/remove_user_request_ticket'

class RemoveUserRequestsController < RequestsController
  protected
  def new_request
    RemoveUserRequest.new(time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::RemoveUserRequestTicket
  end

  def parse_request_from_params
    RemoveUserRequest.new(params[:remove_user_request])
  end
end
