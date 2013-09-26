require 'zendesk/ticket/named_contact_ticket'
require 'support/requests/named_contact'

class NamedContactsController < RequestsController
  include Support::Requests

  protected
  def new_request
    NamedContact.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::NamedContactTicket
  end

  def parse_request_from_params
    NamedContact.new(params[:named_contact])
  end

  def set_requester_on(request)
    request.requester = Support::Requests::Requester.new(params[:named_contact][:requester])
  end
end
