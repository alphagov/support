require 'zendesk/ticket/new_feature_request_ticket'
require 'support/requests/new_feature_request'

class NewFeatureRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    Support::Requests::NewFeatureRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::NewFeatureRequestTicket
  end

  def parse_request_from_params
    NewFeatureRequest.new(new_feature_request_params)
  end

  def new_feature_request_params
    params.require(:support_requests_new_feature_request).permit(
      :request_context, :title, :user_need, :url_of_example,
      requester_attributes: [:email, :name, :collaborator_emails],
      time_constraint_attributes: [:not_before_date, :needed_by_date, :time_constraint_reason],
    )
  end
end
