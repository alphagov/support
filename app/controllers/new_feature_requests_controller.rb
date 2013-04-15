require 'new_feature_request_zendesk_ticket'

class NewFeatureRequestsController < RequestsController
  protected
  def request_class
    NewFeatureRequest
  end

  def new_request
    request_class.new(:requester => Requester.new, :time_constraint => TimeConstraint.new)
  end

  def zendesk_ticket_class
    NewFeatureRequestZendeskTicket
  end

  def parse_request_from_params
    request_class.new(params[:new_feature_request])
  end
end