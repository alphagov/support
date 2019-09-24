class ChangesToPublishingAppsRequestsController < RequestsController
protected

  def new_request
    Support::Requests::ChangesToPublishingAppsRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ChangesToPublishingAppsRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ChangesToPublishingAppsRequest.new(new_changes_to_publishing_apps_request_params)
  end

  def new_changes_to_publishing_apps_request_params
    params.require(:support_requests_changes_to_publishing_apps_request).permit(
      :title, :user_need, :feature_evidence,
      requester_attributes: %i[email name collaborator_emails]
    ).to_h
  end
end
