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
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
      requested_user_attributes: %i[name email],
    ).to_h
  end
end
