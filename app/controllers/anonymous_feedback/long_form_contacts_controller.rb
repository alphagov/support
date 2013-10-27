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
    # remapping link => url while the public form submits the 'url' param
    params[:long_form_contact][:url] ||= params[:long_form_contact][:link]
    Anonymous::LongFormContact.new(params[:long_form_contact])
  end
end
