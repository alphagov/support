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

  def process_valid_request(submitted_request)
    super(submitted_request)
    create_or_update_user_in_zendesk(submitted_request.requested_user)
  end

  def create_or_update_user_in_zendesk(requested_user)
    begin
      ZendeskUsers.new(client).create_or_update_user(requested_user)
    rescue ZendeskError => e
      ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    end
  end
end
