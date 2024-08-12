require "gds_zendesk/users"
require "zendesk_api/error"

class CreateNewUserRequestsController < RequestsController
  include ExploreHelper

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
      :access_to_whitehall_publisher,
      :access_to_other_publishing_apps,
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end

  def save_to_zendesk(submitted_request)
    super
    Support::GDS::RequestedUser.new(
      create_or_change_user_request_params.slice(:name, :email, :organisation),
    )
  end

  def organisation_options
    @organisation_options ||= Services.support_api.organisations_list.to_a.map { |o| organisation_title(o) }
  end
end
