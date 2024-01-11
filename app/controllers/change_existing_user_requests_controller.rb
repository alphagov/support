require "gds_zendesk/users"
require "zendesk_api/error"

class ChangeExistingUserRequestsController < RequestsController
protected

  def new_request
    Support::Requests::ChangeExistingUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ChangeExistingUserRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ChangeExistingUserRequest.new(create_or_change_user_request_params)
  end

  def create_or_change_user_request_params
    params.require(:support_requests_change_existing_user_request).permit(
      :action,
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
      requested_user_attributes: %i[name email],
    ).to_h
  end

  def save_to_zendesk(submitted_request)
    super
    create_or_update_user_in_zendesk(submitted_request.requested_user) if submitted_request.for_new_user?
  end

  def create_or_update_user_in_zendesk(requested_user)
    GDS_ZENDESK_CLIENT.users.create_or_update_user(requested_user)
  rescue ZendeskAPI::Error::ClientError => e
    exception_notification_for(e)
  end
end