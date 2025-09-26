class CreateNewUserOrTrainingRequestsController < RequestsController
  include ExploreHelper

  helper_method :organisation_options

  def new
    @use_design_system = true
    super
  end

protected

  def new_request
    Support::Requests::CreateNewUserOrTrainingRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CreateNewUserOrTrainingRequestTicket
  end

  def parse_request_from_params
    Support::Requests::CreateNewUserOrTrainingRequest.new(create_new_user_or_training_request_params)
  end

  def create_new_user_or_training_request_params
    params.require(:support_requests_create_new_user_or_training_request).permit(
      :name,
      :email,
      :organisation,
      :new_or_existing_user,
      :whitehall_training,
      :access_to_other_publishing_apps,
      :writing_for_govuk_training,
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end

  def save_to_zendesk(submitted_request)
    super
    Support::GDS::RequestedUser.new(
      create_new_user_or_training_request_params.slice(:name, :email, :organisation),
    )
  end

  def organisation_options
    @organisation_options ||= Services.support_api.organisations_list.to_a.map { |o| organisation_title(o) }
  end
end
