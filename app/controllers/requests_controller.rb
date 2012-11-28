require "zendesk_request"
require "zendesk_client"

class RequestsController < ApplicationController
  def new
    @request = new_request
  end

  def create
    @request = parse_request_from_params
    if @request.valid?
      raise_ticket(zendesk_ticket_class.new(@request))
    else
      render :new, :status => 400
    end
  end

  private
  def raise_ticket(ticket)
    load_client

    ticket = ZendeskRequest.raise_ticket(@client, ticket)

    if ticket
      redirect_to acknowledge_path
    else
      return render "support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
    end
  end

  def load_client
    @client = ZendeskClient.get_client(logger)
  end
end