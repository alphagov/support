require 'zendesk/ticket/unpublish_content_request_ticket'
require 'support/requests/unpublish_content_request'

class UnpublishContentRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    UnpublishContentRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::UnpublishContentRequestTicket
  end

  def parse_request_from_params
    UnpublishContentRequest.new(params[:support_requests_unpublish_content_request])
  end
end
