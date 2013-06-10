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
    NewFeatureRequest.new(params[:support_requests_new_feature_request])
  end
end