require "zendesk_tickets"
require "zendesk_client"

class RequestsController < ApplicationController
  def new
    @request = new_request
  end

  def create
    @request = parse_request_from_params
    if @request.valid?
      process_valid_request(@request)
    else
      render :new, :status => 400
    end
  end

  protected
  def process_valid_request(submitted_request)
    raise_ticket(zendesk_ticket_class.new(submitted_request))
  end

  private
  def raise_ticket(ticket)
    ticket = ZendeskTickets.new(client).raise_ticket(ticket)

    if ticket
      redirect_to acknowledge_path
    else
      return render "support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
    end
  end

  def client
    ZendeskClient.get_client(logger)
  end
end