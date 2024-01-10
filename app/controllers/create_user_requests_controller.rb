class CreateUserRequestsController < RequestsController
  include ExploreHelper

protected

  def new_request
    @organisations_list = parse_organisations(support_api.organisations_list)
    Support::Requests::CreateUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateUserRequestTicket
  end

  def parse_request_from_params
    Support::Requests::CreateUserRequest.new(create_user_request_params)
  end

  def create_user_request_params
    params.require(:support_requests_create_user_request).permit(
      :user_name,
      :user_email,
      :organisation,
      :other_apps,
    ).to_h
  end

  def save_to_zendesk(submitted_request)
    super
    requested_user = OpenStruct.new(
      name: submitted_request.user_name,
      email: submitted_request.user_email,
    )
    create_or_update_user_in_zendesk(requested_user)
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
