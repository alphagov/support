require 'remove_user_request_zendesk_ticket'

class RemoveUserRequestsController < RequestsController
  protected
  def request_class
    RemoveUserRequest
  end

  def new_request
    request_class.new(time_constraint: TimeConstraint.new)
  end

  def zendesk_ticket_class
    RemoveUserRequestZendeskTicket
  end

  def parse_request_from_params
    request_class.new(params[:remove_user_request])
  end
end
