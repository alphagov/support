require 'zendesk/ticket/long_form_contact_ticket'
require 'support/requests/anonymous/long_form_contact'

class AnonymousFeedback::LongFormContactsController < AnonymousFeedbackController
  include Support::Requests

  protected
  def new_request
    Anonymous::LongFormContact.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::LongFormContactTicket
  end

  def parse_request_from_params
    Anonymous::LongFormContact.new(params[:long_form_contact])
  end
end
