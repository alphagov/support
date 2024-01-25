require "gds_zendesk/users"
require "zendesk_api/error"

class CreateNewUserRequestsController < RequestsController
  include ExploreHelper

  layout "design_system"
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder
  helper_method :organisation_options

protected

  def new_request
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
      :name,
      :email,
      :organisation,
      :requires_additional_access,
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end

  def save_to_zendesk(submitted_request)
    super
    requested_user = Support::GDS::RequestedUser.new(
      create_or_change_user_request_params.slice(:name, :email, :organisation),
    )
    create_or_update_user_in_zendesk(requested_user)
  end

  def create_or_update_user_in_zendesk(requested_user)
    GDS_ZENDESK_CLIENT.users.create_or_update_user(requested_user)
  rescue ZendeskAPI::Error::ClientError => e
    exception_notification_for(e)
  end

  def organisation_options
    @organisation_options ||= ["", "None"] + support_api.organisations_list.to_a.map { |o| organisation_title(o) }
  end

  def validation_errors_for_alert = nil

private

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end
end
