require 'zendesk/ticket/new_feature_request_ticket'

class NewFeatureRequestsController < RequestsController
  protected
  def new_request
    NewFeatureRequest.new(:requester => Requester.new, :time_constraint => TimeConstraint.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::NewFeatureRequestTicket
  end

  def parse_request_from_params
    NewFeatureRequest.new(params[:new_feature_request])
  end
end