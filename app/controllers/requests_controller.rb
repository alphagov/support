require "zendesk_tickets"
require 'gds_zendesk/zendesk_error'

class RequestsController < ApplicationController
  def new
    @request = new_request
  end

  def create
    @request = parse_request_from_params
    if @request.valid?
      process_valid_request(@request)
    else
      render :new, status: 400
    end
  end

  protected
  def process_valid_request(submitted_request)
    raise_ticket(zendesk_ticket_class.new(submitted_request))
  end

  private
  def raise_ticket(ticket)
    ticket = ZendeskTickets.new(GDS_ZENDESK_CLIENT).raise_ticket(ticket)

    if ticket
      redirect_to acknowledge_path
    else
      return render "support/zendesk_error", locals: { error_string: "Zendesk timed out", ticket: ticket }
    end
  rescue GDSZendesk::ZendeskError => e
    ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    render "support/zendesk_error", status: 500, locals: { error_string: e.underlying_message, 
                                                           ticket: ticket }
  end
end
