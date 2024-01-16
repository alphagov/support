require "gds_zendesk/users"
require "zendesk_api/error"

class CreateNewUserRequestsController < RequestsController
  include ExploreHelper

protected

  def new_request
    @organisations_list = support_api.organisations_list.to_a.map { |o| organisation_title(o) }
    Support::Requests::CreateNewUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateNewUserRequestTicket
  end

  def parse_request_from_params
    Support::Requests::CreateNewUserRequest.new(create_or_change_user_request_params)
  end

  def create_or_change_user_request_params
    params.require(:support_requests_create_new_user_request).permit(
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
      requested_user_attributes: %i[name email organisation],
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

private

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end
end
