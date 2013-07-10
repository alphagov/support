require 'zendesk/ticket/create_or_change_user_request_ticket'
require 'support/requests/create_or_change_user_request'
require 'gds_zendesk/users'
require 'zendesk_api/error'

class CreateOrChangeUserRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    CreateOrChangeUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateOrChangeUserRequestTicket
  end

  def parse_request_from_params
    CreateOrChangeUserRequest.new(params[:support_requests_create_or_change_user_request])
  end

  def process_valid_request(submitted_request)
    super(submitted_request)
    create_or_update_user_in_zendesk(submitted_request.requested_user)
  end

  def create_or_update_user_in_zendesk(requested_user)
    begin
      GDSZendesk::Users.new(GDS_ZENDESK_CLIENT).create_or_update_user(requested_user)
    rescue ZendeskAPI::Error::ClientError => e
      exception_notification_for(e)
    end
  end
end
