require 'content_change_request_zendesk_ticket'

class ContentChangeRequestsController < RequestsController
  protected
  def request_class
    ContentChangeRequest
  end

  def new_request
    request_class.new(:requester => Requester.new, :time_constraint => TimeConstraint.new)
  end

  def zendesk_ticket_class
    ContentChangeRequestZendeskTicket
  end

  def parse_request_from_params
    request_class.new(params[:content_change_request])
  end
end
