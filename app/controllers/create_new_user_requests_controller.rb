require 'zendesk/ticket/create_new_user_request_ticket'
require 'gds_zendesk/users'
require 'gds_zendesk/zendesk_error'

class CreateNewUserRequestsController < RequestsController
  protected
  def new_request
    CreateNewUserRequest.new(requested_user: RequestedUser.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateNewUserRequestTicket
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
      GDSZendesk::Users.new(GDS_ZENDESK_CLIENT).create_or_update_user(requested_user)
    rescue GDSZendesk::ZendeskError => e
      ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    end
  end
end
