require 'create_new_user_request_zendesk_ticket'
require 'zendesk_users'

class CreateNewUserRequestsController < RequestsController
  protected
  def new_request
    CreateNewUserRequest.new(requester: Requester.new, requested_user: RequestedUser.new)
  end

  def zendesk_ticket_class
    CreateNewUserRequestZendeskTicket
  end

  def parse_request_from_params
    CreateNewUserRequest.new(params[:create_new_user_request])
  end

  def deal_with(submitted_request)
    super(submitted_request)
    ZendeskUsers.new(client).create_or_update_user(submitted_request.requested_user)
  end
end
