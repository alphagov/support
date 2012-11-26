require 'create_new_user_request_zendesk_ticket'

class CreateNewUserRequestsController < RequestsController
  protected
  def new_request
    CreateNewUserRequest.new(:requester => Requester.new)
  end

  def zendesk_ticket_class
    CreateNewUserRequestZendeskTicket
  end

  def parse_request_from_params
    CreateNewUserRequest.new(params[:create_new_user_request])
  end
end
