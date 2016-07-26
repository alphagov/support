require 'zendesk/ticket/changes_to_publishing_apps_request_ticket'
require 'support/requests/changes_to_publishing_apps_request'

class ChangesToPublishingAppsRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    Support::Requests::ChangesToPublishingAppsRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ChangesToPublishingAppsRequestTicket
  end

  def parse_request_from_params
    ChangesToPublishingAppsRequest.new(new_changes_to_publishing_apps_request_params)
  end

  def new_changes_to_publishing_apps_request_params
    params.require(:support_requests_changes_to_publishing_apps_request).permit(
      :request_context, :title, :user_need, :url_of_example,
      requester_attributes: [:email, :name, :collaborator_emails],
      time_constraint_attributes: [:not_before_date, :needed_by_date, :time_constraint_reason],
    )
  end
end
